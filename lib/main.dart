import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_flutter_app/core/di/injection.dart';
import 'package:my_flutter_app/core/router/router_exports.dart';
import 'package:my_flutter_app/core/strings.dart';
import 'package:my_flutter_app/core/theme/colors.dart';
import 'package:my_flutter_app/core/theme/fonts.dart';
import 'package:my_flutter_app/core/theme/theme_provider.dart';
import 'package:my_flutter_app/core/utils/error_handler.dart';
import 'package:my_flutter_app/core/utils/image_path_service.dart';
import 'package:my_flutter_app/core/utils/performance_monitor.dart';
import 'package:provider/provider.dart';

void main() {
  PerformanceMonitor.startTiming('App Startup');

  // Lock orientation to portrait only
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Setup global error handling
  GlobalErrorHandler.setup();

  // Run app with error handling zone
  GlobalErrorHandler.runAppWithErrorHandling(() {
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

  // Cache themes to avoid rebuilding them on every build
  static final ThemeData _lightTheme = _buildLightThemeStatic();
  static final ThemeData _darkTheme = _buildDarkThemeStatic();

  @override
  void initState() {
    super.initState();
    PerformanceMonitor.startTiming('Widget Initialization');
    // Initialize dependency injection asynchronously
    WidgetsBinding.instance.addPostFrameCallback((_) {
      PerformanceMonitor.endTiming('Widget Initialization');
      _initializeApp();
    });
  }

  Future<void> _initializeApp() async {
    try {
      PerformanceMonitor.startTiming('Dependency Injection');

      // Initialize dependency injection in a separate isolate to avoid blocking UI
      await Future.microtask(() {
        configureDependencies();
      });

      PerformanceMonitor.endTiming('Dependency Injection');

      // Prewarm documents directory to avoid jank on first image decode
      try {
        await getIt<ImagePathService>().prewarmDocumentsDirectory();
      } catch (_) {
        // Ignore prewarm failures
      }

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
        PerformanceMonitor.endTiming('App Startup');
        PerformanceMonitor.printSummary();
      }
    } catch (e) {
      print('❌ Error initializing app: $e');
      if (mounted) {
        setState(() {
          _isInitialized = true; // Still show the app even if DI fails
        });
        PerformanceMonitor.endTiming('App Startup');
      }
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppStrings.appName,
        home: const Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => getIt<AppTabController>()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: AppStrings.appName,
            theme: _lightTheme,
            darkTheme: _darkTheme,
            themeMode: themeProvider.themeMode,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }

  /// Build light theme (static version for caching)
  static ThemeData _buildLightThemeStatic() {
    PerformanceMonitor.startTiming('Light Theme Building');
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
    PerformanceMonitor.endTiming('Light Theme Building');
    return theme;
  }

  /// Build dark theme (static version for caching)
  static ThemeData _buildDarkThemeStatic() {
    PerformanceMonitor.startTiming('Dark Theme Building');
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
    PerformanceMonitor.endTiming('Dark Theme Building');
    return theme;
  }
}
