import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:my_flutter_app/core/di/injection.dart';
import 'package:my_flutter_app/core/router/router_exports.dart';
import 'package:my_flutter_app/core/services/biometric_auth_provider.dart';
import 'package:my_flutter_app/core/services/splash_settings_provider.dart';
import 'package:my_flutter_app/core/strings.dart';
import 'package:my_flutter_app/core/theme/colors.dart';
import 'package:my_flutter_app/core/theme/fonts.dart';
import 'package:my_flutter_app/core/theme/theme_provider.dart';
import 'package:my_flutter_app/core/utils/date_formatter.dart';
import 'package:my_flutter_app/core/utils/error_handler.dart';
import 'package:my_flutter_app/core/utils/image_path_service.dart';
import 'package:provider/provider.dart';

void main() async {
  // Setup global error handling first
  GlobalErrorHandler.setup();

  // Run everything in the error handling zone
  GlobalErrorHandler.runAppWithErrorHandling(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Load environment variables
    await dotenv.load(fileName: ".env");

    // Lock orientation to portrait only (with error handling)
    try {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    } catch (e) {
      // Ignore orientation setting errors on some devices
      developer.log(
        'Warning: Could not set device orientation: $e',
        name: 'Main',
      );
    }

    // Run the app
    runApp(const MyApp());
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isInitialized = false;
  late final GoRouter _router = AppRouter.router;

  // Cache themes to avoid rebuilding them on every build
  static final ThemeData _lightTheme = _buildLightThemeStatic();
  static final ThemeData _darkTheme = _buildDarkThemeStatic();

  @override
  void initState() {
    super.initState();
    // Initialize dependency injection asynchronously
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeApp();
    });
  }

  Future<void> _initializeApp() async {
    try {
      // Initialize dependency injection in a separate isolate to avoid blocking UI
      await Future.microtask(() {
        configureDependencies();
      });

      // Prewarm documents directory to avoid jank on first image decode
      try {
        await getIt<ImagePathService>().prewarmDocumentsDirectory();
      } catch (_) {
        // Ignore prewarm failures
      }

      // Prewarm intl date formatting and cache today's formatted date
      try {
        await DateFormatter.prewarmTodayFormatted();
      } catch (_) {
        // Ignore prewarm failures; fallback getter will compute on demand
      }

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      developer.log('❌ Error initializing app: $e', name: 'Main');
      if (mounted) {
        setState(() {
          _isInitialized = true; // Still show the app even if DI fails
        });
      }
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Don't show any loading - router will show splash screen immediately
    if (!_isInitialized) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppStrings.appName,
        home: Scaffold(body: Center(child: SizedBox.shrink())),
      );
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => getIt<AppTabController>()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => BiometricAuthProvider()),
        ChangeNotifierProvider(create: (context) => SplashSettingsProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: AppStrings.appName,
            theme: _lightTheme,
            darkTheme: _darkTheme,
            themeMode: themeProvider.themeMode,
            routerConfig: _router,
          );
        },
      ),
    );
  }

  /// Build light theme (static version for caching)
  static ThemeData _buildLightThemeStatic() {
    final colorScheme = AppColors.lightColorScheme;
    final theme = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      textTheme: AppTypography.textTheme,
      dividerColor: colorScheme.outline,
      cardColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
      ),
    );
    return theme;
  }

  /// Build dark theme (static version for caching)
  static ThemeData _buildDarkThemeStatic() {
    final colorScheme = AppColors.darkColorScheme;
    final theme = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      textTheme: AppTypography.textTheme,
      dividerColor: colorScheme.outline,
      cardColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
      ),
    );
    return theme;
  }
}
