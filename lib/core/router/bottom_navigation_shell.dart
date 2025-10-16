import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_flutter_app/core/di/injection.dart';
import 'package:my_flutter_app/core/router/tab_controller.dart';
import 'package:my_flutter_app/core/strings.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
import 'package:my_flutter_app/features/compose/presentation/bloc/compose_bloc.dart';
import 'package:my_flutter_app/features/compose/presentation/screens/compose_home_screen.dart';
import 'package:my_flutter_app/features/memory/presentation/bloc/memory_bloc.dart';
import 'package:my_flutter_app/features/memory/presentation/screens/memory_screen.dart';
import 'package:my_flutter_app/features/settings/presentation/screens/settings_screen.dart';
import 'package:my_flutter_app/shared/presentation/widgets/docked_toolbar.dart';
import 'package:provider/provider.dart';

/// Bottom navigation shell that wraps the main tab content
class BottomNavigationShell extends StatefulWidget {
  const BottomNavigationShell({super.key});

  @override
  State<BottomNavigationShell> createState() => _BottomNavigationShellState();
}

class _BottomNavigationShellState extends State<BottomNavigationShell> {
  List<Widget>? _pages;
  bool _isToolbarVisible = true;
  // We use NotificationListener to detect scroll direction across nested scrollables

  void _handleScrollNotification(UserScrollNotification notification) {
    final direction = notification.direction;
    if (direction == ScrollDirection.reverse && _isToolbarVisible) {
      setState(() => _isToolbarVisible = false);
    } else if (direction == ScrollDirection.forward && !_isToolbarVisible) {
      setState(() => _isToolbarVisible = true);
    }
  }

  List<Widget> get pages {
    _pages ??= <Widget>[
      BlocProvider(
        create: (context) => getIt<MemoryBloc>(),
        child: const MemoryScreen(),
      ),
      BlocProvider(
        create: (context) => getIt<ComposeBloc>(),
        child: const ComposeHomeScreen(),
      ),
      const SettingsScreen(),
    ];
    return _pages!;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppTabController>(
      builder: (context, tabController, child) {
        return Scaffold(
          extendBody: true,
          body: NotificationListener<UserScrollNotification>(
            onNotification: (notification) {
              _handleScrollNotification(notification);
              return false; // allow scroll to propagate
            },
            child: Stack(
              children: [
                IndexedStack(
                  index: tabController.currentIndex,
                  children: pages,
                ),
                Positioned.fill(
                  child: IgnorePointer(
                    ignoring: true,
                    child: const SizedBox.expand(),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: UIConstants.dockedBarBottomOffset,
                  child: IgnorePointer(
                    ignoring: false,
                    child: DockedToolbar(
                      items: const [
                        DockedToolbarItem(
                          emoji: '📸',
                          label: AppStrings.memory,
                        ),
                        DockedToolbarItem(
                          emoji: '✍️',
                          label: AppStrings.compose,
                        ),
                        DockedToolbarItem(
                          emoji: '⚙️',
                          label: AppStrings.settings,
                        ),
                      ],
                      currentIndex: tabController.currentIndex,
                      onTap: (int index) {
                        tabController.setIndex(index);
                      },
                      isVisible: _isToolbarVisible,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
