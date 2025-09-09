import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/router/tab_controller.dart';
import 'package:my_flutter_app/core/strings.dart';
import 'package:my_flutter_app/core/theme/fonts.dart';
import 'package:my_flutter_app/features/compose/presentation/screens/compose_screen.dart';
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
  // Define the pages locally to avoid navigation transitions
  static const List<Widget> _pages = <Widget>[
    MemoryScreen(),
    ComposeScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<AppTabController>(
      builder: (context, tabController, child) {
        return Scaffold(
          body: IndexedStack(
            index: tabController.currentIndex,
            children: _pages,
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
