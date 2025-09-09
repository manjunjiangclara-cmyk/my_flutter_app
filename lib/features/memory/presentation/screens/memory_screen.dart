import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/strings.dart';
import 'package:my_flutter_app/core/theme/fonts.dart';
import 'package:my_flutter_app/core/theme/spacings.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
import 'package:my_flutter_app/features/journal/presentation/widgets/timeline_indicator.dart';
import 'package:my_flutter_app/features/memory/presentation/models/memory_card_model.dart';
import 'package:my_flutter_app/features/memory/presentation/providers/memory_provider.dart';
import 'package:my_flutter_app/features/memory/presentation/widgets/memory_card.dart';
import 'package:provider/provider.dart';

class MemoryScreen extends StatelessWidget {
  const MemoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppStrings.myMemories,
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
      AppStrings.currentMonthYear,
      style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold),
    );
  }
}

/// Renders a list of memories with a vertical timeline indicator.
class _MemoryList extends StatelessWidget {
  const _MemoryList();

  @override
  Widget build(BuildContext context) {
    return Consumer<MemoryData>(
      builder: (BuildContext context, MemoryData memoryData, Widget? child) {
        return ListView.builder(
          itemCount: memoryData.memories.length,
          itemBuilder: (BuildContext context, int index) {
            final MemoryCardModel memory = memoryData.memories[index];
            final Color primaryColor = Theme.of(context).colorScheme.primary;
            final bool isFirst = index == 0;
            final bool isLast = index == memoryData.memories.length - 1;

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
        );
      },
    );
  }
}
