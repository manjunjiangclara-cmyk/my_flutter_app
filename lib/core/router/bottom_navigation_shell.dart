import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_flutter_app/core/router/tab_controller.dart';
import 'package:my_flutter_app/core/strings.dart';
import 'package:my_flutter_app/core/theme/fonts.dart';
import 'package:my_flutter_app/features/compose/presentation/screens/compose_home_screen.dart';
import 'package:my_flutter_app/features/memory/presentation/bloc/memory_bloc.dart';
import 'package:my_flutter_app/features/memory/presentation/screens/memory_screen.dart';
import 'package:my_flutter_app/features/settings/presentation/screens/settings_screen.dart';
import 'package:my_flutter_app/shared/data/datasources/journal_local_datasource.dart';
import 'package:my_flutter_app/shared/data/repositories_impl/journal_repository_impl.dart';
import 'package:my_flutter_app/shared/domain/usecases/get_journals.dart';
import 'package:my_flutter_app/shared/presentation/widgets/bottom_nav_item.dart';
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
    if (_pages == null) {
      // Create the dependency chain for GetJournals
      final localDataSource = JournalLocalDataSourceImpl();
      final repository = JournalRepositoryImpl(
        localDataSource: localDataSource,
      );
      final getJournals = GetJournals(repository);

      // Define the pages locally to avoid navigation transitions
      _pages = <Widget>[
        BlocProvider(
          create: (context) => MemoryBloc(getJournals: getJournals),
          child: const MemoryScreen(),
        ),
        const ComposeHomeScreen(),
        const SettingsScreen(),
      ];
    }
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
              HapticFeedback.lightImpact();
              tabController.setIndex(index);
            },
            items: <BottomNavigationBarItem>[
              BottomNavItem(
                emoji: '📸',
                label: AppStrings.memory,
              ).build(context),
              BottomNavItem(
                emoji: '✍️',
                label: AppStrings.compose,
              ).build(context),
              BottomNavItem(
                emoji: '⚙️',
                label: AppStrings.settings,
              ).build(context),
            ],
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant,
            unselectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant,
            selectedLabelStyle: AppTypography.labelMedium,
            unselectedLabelStyle: AppTypography.labelSmall,
          ),
        );
      },
    );
  }
}
