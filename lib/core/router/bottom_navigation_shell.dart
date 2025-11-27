import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_flutter_app/core/di/injection.dart';
import 'package:my_flutter_app/core/router/tab_controller.dart';
import 'package:my_flutter_app/core/services/journal_change_notifier.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
import 'package:my_flutter_app/features/compose/presentation/bloc/compose_bloc.dart';
import 'package:my_flutter_app/features/compose/presentation/bloc/compose_state.dart';
import 'package:my_flutter_app/features/compose/presentation/screens/compose_home_screen.dart';
import 'package:my_flutter_app/features/memory/presentation/bloc/memory_bloc.dart';
import 'package:my_flutter_app/features/memory/presentation/bloc/memory_event.dart';
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
  double _elevationT = 0.0;
  late final PageController _pageController;
  double _pageProgress = 0.0;
  bool _scrollListenerAttached = false;
  int _previousRoundedPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _pageProgress = 0.0;
    _previousRoundedPage = 0;
    _pageController.addListener(() {
      final double? p = _pageController.hasClients
          ? _pageController.page
          : null;
      if (p != null) {
        // Detect when page crosses an integer boundary (screen transition)
        final int currentRoundedPage = p.round();
        if (currentRoundedPage != _previousRoundedPage) {
          // Trigger haptic feedback when crossing screen boundaries
          HapticFeedback.mediumImpact();
          _previousRoundedPage = currentRoundedPage;
        }
        // Update only when it changes meaningfully to avoid rebuild churn
        if ((_pageProgress - p).abs() > 0.001) {
          setState(() => _pageProgress = p);
        }
      }
    });
    // Attach isScrolling listener after first frame when position is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _attachScrollStateListenerIfNeeded();
    });
  }
  // We use NotificationListener to detect scroll direction across nested scrollables

  void _handleUserScroll(UserScrollNotification notification) {
    // Check if PageView is currently scrolling/swiping
    final bool isPageViewScrolling =
        _pageController.hasClients &&
        _pageController.position.isScrollingNotifier.value;

    // Check if we're in the middle of a page transition by examining page progress
    // If page progress is not close to an integer, we're transitioning
    final double distanceFromNearestInteger =
        (_pageProgress - _pageProgress.round()).abs();
    final bool isTransitioning = distanceFromNearestInteger > 0.1;

    // If PageView is scrolling or transitioning, don't process scroll notifications
    // to avoid hiding toolbar during page transitions
    if (isPageViewScrolling || isTransitioning) {
      // Ensure toolbar stays visible during page transitions
      if (!_isToolbarVisible) {
        setState(() => _isToolbarVisible = true);
      }
      return;
    }

    // Only handle scroll-based toolbar visibility on the first page (memory screen)
    // to avoid hiding toolbar when swiping between pages
    final double? currentPage =
        _pageController.hasClients && _pageController.page != null
        ? _pageController.page
        : 0.0;

    // Check if we're exactly on the first page (not transitioning)
    // Use a small threshold to account for floating point precision
    final bool isOnFirstPage =
        currentPage != null && (currentPage - 0.0).abs() < 0.1;

    // Only process scroll notifications when exactly on the first page
    if (!isOnFirstPage) {
      // Always show toolbar when not on first page
      if (!_isToolbarVisible) {
        setState(() => _isToolbarVisible = true);
      }
      return;
    }

    final direction = notification.direction;
    if (direction == ScrollDirection.reverse && _isToolbarVisible) {
      setState(() => _isToolbarVisible = false);
    } else if (direction == ScrollDirection.forward && !_isToolbarVisible) {
      setState(() => _isToolbarVisible = true);
    }
  }

  void _handleScrollMetrics(ScrollMetrics metrics) {
    final double extent = metrics.extentBefore;
    final double start = UIConstants.dockedBarElevScrollStart;
    final double end = UIConstants.dockedBarElevScrollEnd;
    final double rawT = (extent - start) / (end - start);
    final double clamped = rawT.clamp(0.0, 1.0);

    // Only update when value changes meaningfully to reduce rebuilds
    if ((clamped - _elevationT).abs() > 0.01) {
      setState(() => _elevationT = clamped);
    }
  }

  List<Widget> get pages {
    _pages ??= <Widget>[
      const MemoryScreen(),
      const ComposeHomeScreen(),
      const SettingsScreen(),
    ];
    return _pages!;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _attachScrollStateListenerIfNeeded() {
    if (!_pageController.hasClients || _scrollListenerAttached) return;
    try {
      _pageController.position.isScrollingNotifier.addListener(
        _onScrollStateChanged,
      );
      _scrollListenerAttached = true;
    } catch (_) {
      // Position might not be ready yet; retry next frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _attachScrollStateListenerIfNeeded();
      });
    }
  }

  void _onScrollStateChanged() {
    // When scrolling stops, snap the tab index to the final page only
    if (!_pageController.position.isScrollingNotifier.value) {
      final double? page = _pageController.page;
      if (page != null) {
        final int finalIndex = page.round();
        final appTabs = Provider.of<AppTabController>(context, listen: false);
        if (finalIndex != appTabs.currentIndex) {
          appTabs.setIndex(finalIndex);
        }
        // Ensure toolbar is visible when not on first page
        if (finalIndex != 0 && !_isToolbarVisible) {
          setState(() => _isToolbarVisible = true);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppTabController>(
      builder: (context, tabController, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<MemoryBloc>(create: (_) => getIt<MemoryBloc>()),
            BlocProvider<ComposeBloc>(create: (_) => getIt<ComposeBloc>()),
          ],
          child: Scaffold(
            extendBody: true,
            body: AnimatedBuilder(
              animation: getIt<JournalChangeNotifier>(),
              builder: (context, _) {
                final notifier = getIt<JournalChangeNotifier>();
                if (notifier.hasPendingChange &&
                    tabController.currentIndex == 0) {
                  notifier.consume();
                  context.read<MemoryBloc>().add(
                    const MemoryRefreshRequested(),
                  );
                }
                return BlocListener<ComposeBloc, ComposeState>(
                  listenWhen: (previous, current) =>
                      current is ComposePostSuccess,
                  listener: (context, state) {
                    // For in-shell compose success, refresh immediately and go to Memory
                    context.read<MemoryBloc>().add(
                      const MemoryRefreshRequested(),
                    );
                    tabController.goToMemory();
                  },
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification is UserScrollNotification) {
                        _handleUserScroll(notification);
                      }
                      _handleScrollMetrics(notification.metrics);
                      return false; // allow scroll to propagate
                    },
                    child: Stack(
                      children: [
                        PageView(controller: _pageController, children: pages),
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
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 180),
                              switchInCurve: Curves.easeInOutCubic,
                              switchOutCurve: Curves.easeInOutCubic,
                              transitionBuilder: (child, animation) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                              child: DockedToolbar(
                                key: ValueKey<bool>(
                                  tabController.currentIndex == 0,
                                ),
                                items: const [
                                  DockedToolbarItem(
                                    icon: Icons.book,
                                    label: '',
                                  ),
                                  DockedToolbarItem(
                                    icon: Icons.edit,
                                    label: '',
                                  ),
                                  DockedToolbarItem(
                                    icon: Icons.settings,
                                    label: '',
                                  ),
                                ],
                                currentIndex: tabController.currentIndex,
                                onTap: (int index) {
                                  // Animate to the requested page; AppTabController syncs in onPageChanged
                                  if (_pageController.hasClients) {
                                    _pageController.animateToPage(
                                      index,
                                      duration: UIConstants.defaultAnimation,
                                      curve: Curves.easeInOutCubic,
                                    );
                                  }
                                },
                                isVisible: _isToolbarVisible,
                                elevationT: _elevationT,
                                useLiquidGlass: true,
                                selectedProgress: _pageController.hasClients
                                    ? (_pageController.page ??
                                          tabController.currentIndex.toDouble())
                                    : tabController.currentIndex.toDouble(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
