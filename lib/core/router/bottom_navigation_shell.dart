import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_flutter_app/core/di/injection.dart';
import 'package:my_flutter_app/core/router/tab_controller.dart';
import 'package:my_flutter_app/core/strings.dart';
import 'package:my_flutter_app/core/theme/fonts.dart';
import 'package:my_flutter_app/features/compose/presentation/screens/compose_home_screen.dart';
import 'package:my_flutter_app/features/memory/presentation/bloc/memory_bloc.dart';
import 'package:my_flutter_app/features/memory/presentation/screens/memory_screen.dart';
import 'package:my_flutter_app/features/settings/presentation/screens/settings_screen.dart';
import 'package:provider/provider.dart';

/// Bottom navigation shell that wraps the main tab content
class BottomNavigationShell extends StatefulWidget {
  const BottomNavigationShell({super.key});

  @override
  State<BottomNavigationShell> createState() => _BottomNavigationShellState();
}

class _BottomNavigationShellState extends State<BottomNavigationShell> {
  List<Widget>? _pages;

  List<Widget> get pages {
    _pages ??= <Widget>[
      BlocProvider(
        create: (context) => getIt<MemoryBloc>(),
        child: const MemoryScreen(),
      ),
      const ComposeHomeScreen(),
      const SettingsScreen(),
    ];
    return _pages!;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppTabController>(
      builder: (context, tabController, child) {
        return Scaffold(
          body: IndexedStack(
            index: tabController.currentIndex,
            children: pages,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: tabController.currentIndex,
            onTap: (int index) {
              tabController.setIndex(index);
            },
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Text('📸', style: AppTypography.titleMedium),
                label: AppStrings.memory,
              ),
              BottomNavigationBarItem(
                icon: Text('✍️', style: AppTypography.titleMedium),
                label: AppStrings.compose,
              ),
              BottomNavigationBarItem(
                icon: Text('⚙️', style: AppTypography.titleMedium),
                label: AppStrings.settings,
              ),
            ],
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: AppTypography.labelSmall,
            unselectedLabelStyle: AppTypography.labelSmall,
          ),
        );
      },
    );
  }
}
