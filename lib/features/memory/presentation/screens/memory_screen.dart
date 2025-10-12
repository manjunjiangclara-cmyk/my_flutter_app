import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_flutter_app/core/theme/fonts.dart';
import 'package:my_flutter_app/core/theme/spacings.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
import 'package:my_flutter_app/features/memory/presentation/bloc/memory_bloc.dart';
import 'package:my_flutter_app/features/memory/presentation/bloc/memory_event.dart';
import 'package:my_flutter_app/features/memory/presentation/bloc/memory_state.dart';
import 'package:my_flutter_app/features/memory/presentation/models/memory_card_model.dart';
import 'package:my_flutter_app/features/memory/presentation/strings/memory_strings.dart';
import 'package:my_flutter_app/features/memory/presentation/widgets/memory_card.dart';
import 'package:my_flutter_app/features/memory/presentation/widgets/month_year_header.dart';
import 'package:my_flutter_app/features/memory/presentation/widgets/timeline_indicator.dart';
import 'package:my_flutter_app/shared/presentation/widgets/refresh_indicator.dart';

class MemoryScreen extends StatelessWidget {
  const MemoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _MemoryScreenView();
  }
}

class _MemoryScreenView extends StatelessWidget {
  const _MemoryScreenView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          MemoryStrings.myMemories,
          style: AppTypography.displayLarge,
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: ClipRect(
          child: Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: UIConstants.barBlurSigma,
                  sigmaY: UIConstants.barBlurSigma,
                ),
                child: Container(
                  color: Theme.of(context).colorScheme.surface.withValues(
                    alpha: UIConstants.barOverlayOpacity,
                  ),
                ),
              ),
              // bottom edge fade to avoid a hard cutoff
              Align(
                alignment: Alignment.bottomCenter,
                child: IgnorePointer(
                  child: Container(
                    height: UIConstants.barEdgeFadeHeight,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Theme.of(context).colorScheme.surface.withValues(
                            alpha: UIConstants.barEdgeFadeStartOpacity,
                          ),
                          Theme.of(
                            context,
                          ).colorScheme.surface.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: UIConstants.defaultPadding),
        child: const Column(children: [Expanded(child: _MemoryList())]),
      ),
    );
  }
}

/// Renders a list of memories with a vertical timeline indicator.
class _MemoryList extends StatefulWidget {
  const _MemoryList();

  @override
  State<_MemoryList> createState() => _MemoryListState();
}

class _MemoryListState extends State<_MemoryList> {
  // Track which month-year groups are expanded (all expanded by default)
  final Set<MonthYearKey> _expandedGroups = <MonthYearKey>{};
  bool _hasLoadedData = false;

  @override
  void initState() {
    super.initState();
    // Load data when the widget is first created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_hasLoadedData) {
        context.read<MemoryBloc>().add(const MemoryLoadRequested());
        _hasLoadedData = true;
      }
    });
  }

  /// Toggles the expanded state of a month-year group
  void _toggleGroup(MonthYearKey monthYearKey) {
    setState(() {
      if (_expandedGroups.contains(monthYearKey)) {
        _expandedGroups.remove(monthYearKey);
      } else {
        _expandedGroups.add(monthYearKey);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MemoryBloc, MemoryState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.errorMessage != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.errorMessage!),
                const SizedBox(height: Spacing.md),
                ElevatedButton(
                  onPressed: () => context.read<MemoryBloc>().add(
                    const MemoryLoadRequested(),
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final memories = state.memories;

        if (memories.isEmpty) {
          return AppRefreshIndicator(
            onRefresh: () async {
              context.read<MemoryBloc>().add(const MemoryRefreshRequested());
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: const Center(child: Text(MemoryStrings.noMemoriesFound)),
              ),
            ),
          );
        }

        // Use grouped memories from state
        final groupedMemories = state.groupedMemories;
        final sortedKeys = state.sortedGroupKeys;

        // Expand all groups by default if they haven't been toggled yet
        if (_expandedGroups.isEmpty && sortedKeys.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              _expandedGroups.addAll(sortedKeys);
            });
          });
        }

        return AppRefreshIndicator(
          onRefresh: () async {
            context.read<MemoryBloc>().add(const MemoryRefreshRequested());
          },
          child: ListView.builder(
            itemCount: _calculateTotalItemCount(groupedMemories, sortedKeys),
            itemBuilder: (BuildContext context, int index) {
              return _buildGroupedMemoryItem(
                context,
                groupedMemories,
                sortedKeys,
                index,
              );
            },
          ),
        );
      },
    );
  }

  /// Calculates the total number of items including headers and memories
  int _calculateTotalItemCount(
    Map<MonthYearKey, List<MemoryCardModel>> groupedMemories,
    List<MonthYearKey> sortedKeys,
  ) {
    int totalCount = 0;
    for (final key in sortedKeys) {
      totalCount += 1; // Header
      // Only count memories if the group is expanded
      if (_expandedGroups.contains(key)) {
        totalCount += groupedMemories[key]!.length; // Memories
      }
    }
    return totalCount;
  }

  /// Builds a single item in the grouped memory list (either header or memory)
  Widget _buildGroupedMemoryItem(
    BuildContext context,
    Map<MonthYearKey, List<MemoryCardModel>> groupedMemories,
    List<MonthYearKey> sortedKeys,
    int index,
  ) {
    int currentIndex = 0;

    for (final key in sortedKeys) {
      final memories = groupedMemories[key]!;
      final isExpanded = _expandedGroups.contains(key);

      // Check if this index is the header for this group
      if (currentIndex == index) {
        return MonthYearHeader(
          monthYear: key.displayString,
          isExpanded: isExpanded,
          onTap: () => _toggleGroup(key),
        );
      }
      currentIndex++;

      // Check if this index is within the memories for this group
      // Only show memories if the group is expanded
      if (isExpanded && index < currentIndex + memories.length) {
        final memoryIndex = index - currentIndex;
        final memory = memories[memoryIndex];
        final isFirst = memoryIndex == 0;
        final isLast = memoryIndex == memories.length - 1;

        return _KeepAliveMemoryRow(
          key: ValueKey(memory.journalId),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TimelineIndicator(isFirst: isFirst, isLast: isLast),
                const SizedBox(width: Spacing.lg),
                Expanded(
                  child: MemoryCard(
                    key: ValueKey(memory.journalId),
                    memoryCardModel: memory,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      // If group is collapsed, skip the memories
      if (isExpanded) {
        currentIndex += memories.length;
      }
    }

    // Fallback (should not reach here)
    return const SizedBox.shrink();
  }
}

class _KeepAliveMemoryRow extends StatefulWidget {
  final Widget child;

  const _KeepAliveMemoryRow({super.key, required this.child});

  @override
  State<_KeepAliveMemoryRow> createState() => _KeepAliveMemoryRowState();
}

class _KeepAliveMemoryRowState extends State<_KeepAliveMemoryRow>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
