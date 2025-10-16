import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_flutter_app/core/strings.dart';
import 'package:my_flutter_app/core/theme/colors.dart';
import 'package:my_flutter_app/core/theme/fonts.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
import 'package:my_flutter_app/shared/presentation/widgets/expressive_loading_indicator.dart';

/// Splash screen widget that displays app branding and loading indicator
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
  }

  Future<void> _navigateToMainApp() async {
    try {
      // Wait for minimum display duration to show splash screen
      await Future.delayed(UIConstants.splashMinDisplayDuration);

      // Navigate to main app
      if (mounted) {
        context.go('/');
      }
    } catch (e) {
      print('❌ Error during splash screen navigation: $e');
      // Still navigate even if there's an error
      if (mounted) {
        context.go('/');
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
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      body: Center(
        child: AnimatedBuilder(
          animation: Listenable.merge([_fadeAnimation, _scaleAnimation]),
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Logo/Icon
                  Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Container(
                      width: UIConstants.splashLogoSize,
                      height: UIConstants.splashLogoSize,
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.accentDark
                            : AppColors.accentLight,
                        borderRadius: BorderRadius.circular(
                          UIConstants.largeRadius,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color:
                                (isDark
                                        ? AppColors.accentDark
                                        : AppColors.accentLight)
                                    .withValues(alpha: 0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.auto_stories_rounded,
                        size: UIConstants.splashLogoSize * 0.6,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  SizedBox(height: UIConstants.splashVerticalSpacing),

                  // App Title
                  Text(
                    AppStrings.splashTitle,
                    style: AppTypography.displayLarge.copyWith(
                      fontSize: UIConstants.splashTitleFontSize,
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: UIConstants.smallPadding),

                  // App Subtitle
                  Text(
                    AppStrings.splashSubtitle,
                    style: AppTypography.bodyLarge.copyWith(
                      fontSize: UIConstants.splashSubtitleFontSize,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  SizedBox(height: UIConstants.splashVerticalSpacing * 1.5),

                  // Loading Indicator
                  SizedBox(
                    width: UIConstants.splashLoadingIndicatorSize,
                    height: UIConstants.splashLoadingIndicatorSize,
                    child: const ExpressiveLoadingIndicator(),
                  ),

                  SizedBox(height: UIConstants.mediumPadding),

                  // Loading Text
                  Text(
                    AppStrings.splashLoading,
                    style: AppTypography.labelMedium.copyWith(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
