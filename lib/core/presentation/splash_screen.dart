import 'dart:developer' as developer;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_flutter_app/core/services/biometric_auth_service.dart';
import 'package:my_flutter_app/core/services/splash_settings_provider.dart';
import 'package:my_flutter_app/core/strings.dart';
import 'package:my_flutter_app/core/strings/splash_quotes.dart';
import 'package:my_flutter_app/core/theme/fonts.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
import 'package:provider/provider.dart';

/// Splash screen widget that displays app icon and optional quote
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late final _RandomQuote _quote;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _navigateToMainApp();
  }

  void _initializeAnimations() {
    // Fade in animation
    _fadeController = AnimationController(
      duration: UIConstants.splashFadeInDuration,
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    // Scale animation for logo
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    // Start animations
    _fadeController.forward();
    _scaleController.forward();

    // Pick a random quote for this launch
    _quote = _pickRandomQuote();
  }

  Future<void> _navigateToMainApp() async {
    try {
      final showQuote = mounted
          ? context.read<SplashSettingsProvider>().showQuote
          : true;
      // Wait for minimum display duration to show splash screen
      if (showQuote) {
        await Future.delayed(UIConstants.splashMinDisplayDuration);
      }

      // If biometric on launch is enabled, prompt user
      final service = BiometricAuthService.instance;
      await service.init();
      final require = service.requireOnLaunch;
      if (require) {
        final success = await service.authenticate(
          localizedReason: AppStrings.biometricUnlockReason,
        );
        if (!success) {
          // Stay on splash if failed; optionally allow retry by calling again
          return;
        }
      }

      // Graceful fade-out before navigating
      if (mounted) {
        await _fadeController.animateTo(
          0.0,
          duration: UIConstants.splashFadeOutDuration,
          curve: Curves.easeInOut,
        );
        if (mounted) {
          context.go('/');
        }
      }
    } catch (e) {
      developer.log(
        '❌ Error during splash screen navigation: $e',
        name: 'SplashScreen',
      );
      // Still navigate even if there's an error
      if (mounted) {
        await _fadeController.animateTo(
          0.0,
          duration: UIConstants.splashFadeOutDuration,
          curve: Curves.easeInOut,
        );
        if (mounted) {
          context.go('/');
        }
      }
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Center(
        child: AnimatedBuilder(
          animation: Listenable.merge([_fadeAnimation, _scaleAnimation]),
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: UIConstants.splashHorizontalPadding,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: UIConstants.splashQuoteMaxWidth,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // App Icon with scale animation
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: theme.brightness == Brightness.dark
                            ? ColorFiltered(
                                colorFilter: const ColorFilter.mode(
                                  Colors.white,
                                  BlendMode.srcIn,
                                ),
                                child: Image.asset(
                                  AppStrings.splashAppIconPath,
                                  width: UIConstants.splashLogoSize,
                                  height: UIConstants.splashLogoSize,
                                  fit: BoxFit.contain,
                                ),
                              )
                            : Image.asset(
                                AppStrings.splashAppIconPath,
                                width: UIConstants.splashLogoSize,
                                height: UIConstants.splashLogoSize,
                                fit: BoxFit.contain,
                              ),
                      ),

                      // Quote text (conditionally shown below icon)
                      Consumer<SplashSettingsProvider>(
                        builder: (context, splashSettings, _) {
                          if (!splashSettings.showQuote) {
                            return const SizedBox.shrink();
                          }
                          return Column(
                            children: [
                              SizedBox(height: UIConstants.splashVerticalSpacing * 1.5),
                              Text(
                                _quote.text,
                                textAlign: TextAlign.center,
                                style: AppTypography.bodyLarge.copyWith(
                                  fontSize: UIConstants.splashQuoteFontSize,
                                  color: colorScheme.onSurface,
                                  fontWeight: FontWeight.w600,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          );
                        },
                      ),

                      Consumer<SplashSettingsProvider>(
                        builder: (context, splashSettings, _) {
                          if (!splashSettings.showQuote) {
                            return const SizedBox.shrink();
                          }
                          if (_quote.author != null &&
                              _quote.author!.isNotEmpty) {
                            return Column(
                              children: [
                                SizedBox(height: UIConstants.smallPadding),
                                Text(
                                  '— ${_quote.author!}',
                                  textAlign: TextAlign.center,
                                  style: AppTypography.bodyMedium.copyWith(
                                    fontSize: UIConstants.splashAuthorFontSize,
                                    color: colorScheme.onSurfaceVariant,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _RandomQuote {
  final String text;
  final String? author;
  const _RandomQuote(this.text, [this.author]);
}

_RandomQuote _pickRandomQuote() {
  final random = Random();
  const double authorQuoteProbability = 0.75;
  final useWithAuthor = random.nextDouble() < authorQuoteProbability;
  if (useWithAuthor &&
      SplashQuoteStrings.splashQuotesShortWithAuthorsEn.isNotEmpty) {
    final pair =
        SplashQuoteStrings.splashQuotesShortWithAuthorsEn[random.nextInt(
          SplashQuoteStrings.splashQuotesShortWithAuthorsEn.length,
        )];
    final text = pair['q'] ?? '';
    final author = pair['a'] ?? '';
    if (text.isNotEmpty) {
      return _RandomQuote(text, author);
    }
  }
  // Fallback to authorless quotes
  if (SplashQuoteStrings.splashQuotesShortEn.isNotEmpty) {
    final text =
        SplashQuoteStrings.splashQuotesShortEn[random.nextInt(
          SplashQuoteStrings.splashQuotesShortEn.length,
        )];
    return _RandomQuote(text);
  }
  // Ultimate fallback to previous strings
  return _RandomQuote(AppStrings.splashSubtitle);
}
