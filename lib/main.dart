import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/router/router_exports.dart';
import 'package:my_flutter_app/core/strings.dart';
import 'package:my_flutter_app/core/theme/colors.dart';
import 'package:my_flutter_app/core/theme/fonts.dart';
import 'package:my_flutter_app/features/memory/presentation/providers/memory_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MemoryData()),
        ChangeNotifierProvider(create: (context) => AppTabController()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: AppStrings.appName,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: AppColors.primary,
          // colorScheme: AppColors.colorScheme,
          scaffoldBackgroundColor: AppColors.background,
          textTheme: AppTypography.textTheme,
          dividerColor: AppColors.border,
        ),
        routerConfig: AppRouter.router,
      ),
    );
  }
}
