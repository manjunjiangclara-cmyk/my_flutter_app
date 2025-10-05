import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/di/injection.dart';
import 'package:my_flutter_app/core/router/router_exports.dart';
import 'package:my_flutter_app/core/strings.dart';
import 'package:my_flutter_app/core/theme/colors.dart';
import 'package:my_flutter_app/core/theme/fonts.dart';
import 'package:my_flutter_app/core/theme/theme_provider.dart';
import 'package:my_flutter_app/core/utils/app_initialization_service.dart';
import 'package:my_flutter_app/core/utils/error_handler.dart';
import 'package:provider/provider.dart';

void main() {
  // Setup global error handling
  GlobalErrorHandler.setup();

  // Initialize dependency injection
  configureDependencies();

  // Run app immediately - don't wait for initialization
  GlobalErrorHandler.runAppWithErrorHandling(() {
    runApp(const MyApp());
  });

  // Initialize app services in background
  _initializeAppInBackground();
}

/// Initialize app services in background
void _initializeAppInBackground() {
  Future.microtask(() async {
    try {
      print('🚀 Starting background app initialization...');
      final appInitService = getIt<AppInitializationService>();
      await appInitService.initializeApp();
      print('✅ Background initialization completed');
    } catch (e) {
      print('❌ Background initialization failed: $e');
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
            theme: _buildLightTheme(),
            darkTheme: _buildDarkTheme(),
            themeMode: themeProvider.themeMode,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }

  /// Build light theme
  ThemeData _buildLightTheme() {
    final colorScheme = AppColors.lightColorScheme;
    return ThemeData(
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
  }

  /// Build dark theme
  ThemeData _buildDarkTheme() {
    final colorScheme = AppColors.darkColorScheme;
    return ThemeData(
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
  }
}
