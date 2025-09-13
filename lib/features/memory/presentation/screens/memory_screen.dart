import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_flutter_app/core/theme/fonts.dart';
import 'package:my_flutter_app/core/theme/spacings.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
import 'package:my_flutter_app/features/journal/presentation/widgets/timeline_indicator.dart';
import 'package:my_flutter_app/features/memory/presentation/bloc/memory_bloc.dart';
import 'package:my_flutter_app/features/memory/presentation/bloc/memory_event.dart';
import 'package:my_flutter_app/features/memory/presentation/bloc/memory_state.dart';
import 'package:my_flutter_app/features/memory/presentation/models/memory_card_model.dart';
import 'package:my_flutter_app/features/memory/presentation/strings/memory_strings.dart';
import 'package:my_flutter_app/features/memory/presentation/widgets/memory_card.dart';

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
            padding: const EdgeInsets.only(right: UIConstants.defaultPadding),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const _MemoryHeader(),
            const SizedBox(height: Spacing.md),
            const Expanded(child: _MemoryList()),
          ],
        ),
      ),
    );
  }
}

/// Displays the header for the memory list, showing the current month and year.
class _MemoryHeader extends StatelessWidget {
  const _MemoryHeader();

  @override
  Widget build(BuildContext context) {
    return Text(
      MemoryStrings.currentMonthYear,
      style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold),
    );
  }
}

/// Renders a list of memories with a vertical timeline indicator.
class _MemoryList extends StatelessWidget {
  const _MemoryList();

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

        return RefreshIndicator(
          onRefresh: () async {
            context.read<MemoryBloc>().add(const MemoryRefreshRequested());
          },
          child: ListView.builder(
            itemCount: memories.length,
            itemBuilder: (BuildContext context, int index) {
              final MemoryCardModel memory = memories[index];
              final Color primaryColor = Theme.of(context).colorScheme.primary;
              final bool isFirst = index == 0;
              final bool isLast = index == memories.length - 1;

              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TimelineIndicator(
                      isFirst: isFirst,
                      isLast: isLast,
                      dotColor: primaryColor,
                    ),
                    const SizedBox(width: Spacing.lg),
                    Expanded(child: MemoryCard(memoryCardModel: memory)),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
