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
import 'package:my_flutter_app/features/memory/presentation/utils/memory_grouping_utils.dart';
import 'package:my_flutter_app/features/memory/presentation/widgets/memory_card.dart';
import 'package:my_flutter_app/features/memory/presentation/widgets/month_year_header.dart';
import 'package:my_flutter_app/features/memory/presentation/widgets/timeline_indicator.dart';

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
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: UIConstants.smallPadding),
            child: IconButton(
              icon: const Icon(Icons.add_box_rounded),
              iconSize: UIConstants.iconButtonSize,
              onPressed: () {
                // Action for adding a new memory
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(
          left: UIConstants.defaultPadding,
          right: UIConstants.defaultPadding,
          top: UIConstants.defaultPadding,
          bottom: UIConstants.defaultPadding,
        ),
        child: const Expanded(child: _MemoryList()),
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
  final Set<String> _expandedGroups = <String>{};

  /// Toggles the expanded state of a month-year group
  void _toggleGroup(String monthYear) {
    setState(() {
      if (_expandedGroups.contains(monthYear)) {
        _expandedGroups.remove(monthYear);
      } else {
        _expandedGroups.add(monthYear);
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

        final memories = state.filteredMemories;

        if (memories.isEmpty) {
          return RefreshIndicator(
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

        // Group memories by month and year
        final groupedMemories = MemoryGroupingUtils.groupMemoriesByMonthYear(
          memories,
        );
        final sortedKeys = MemoryGroupingUtils.getSortedMonthYearKeys(
          groupedMemories,
        );

        // Expand all groups by default if they haven't been toggled yet
        if (_expandedGroups.isEmpty && sortedKeys.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              _expandedGroups.addAll(sortedKeys);
            });
          });
        }

        return RefreshIndicator(
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
    Map<String, List<MemoryCardModel>> groupedMemories,
    List<String> sortedKeys,
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
    Map<String, List<MemoryCardModel>> groupedMemories,
    List<String> sortedKeys,
    int index,
  ) {
    int currentIndex = 0;

    for (final key in sortedKeys) {
      final memories = groupedMemories[key]!;
      final isExpanded = _expandedGroups.contains(key);

      // Check if this index is the header for this group
      if (currentIndex == index) {
        return MonthYearHeader(
          monthYear: key,
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

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TimelineIndicator(isFirst: isFirst, isLast: isLast),
              const SizedBox(width: Spacing.lg),
              Expanded(child: MemoryCard(memoryCardModel: memory)),
            ],
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
