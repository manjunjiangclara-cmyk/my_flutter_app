import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_flutter_app/core/theme/fonts.dart';
import 'package:my_flutter_app/core/theme/spacings.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
import 'package:my_flutter_app/features/journal/presentation/router/journal_router.dart';
import 'package:my_flutter_app/features/journal/presentation/widgets/image_card.dart';
import 'package:my_flutter_app/features/journal/presentation/widgets/tag_chip.dart';
import 'package:my_flutter_app/features/memory/presentation/models/memory_card_model.dart';

class MemoryCard extends StatelessWidget {
  final MemoryCardModel memoryCardModel;

  // Configurable UI parameters with sensible defaults
  final double imageHeight;
  final double borderRadius;
  final double borderWidth;
  final double cardPadding;
  final double sectionSpacingLarge;
  final double sectionSpacingSmall;
  final double chipHorizontalPadding;
  final double chipVerticalPadding;
  final double tagSpacing;
  final double tagRunSpacing;
  final double locationIconSize;

  const MemoryCard({
    super.key,
    required this.memoryCardModel,
    this.imageHeight = UIConstants.defaultImageSize * 1.5,
    this.borderRadius = UIConstants.defaultCardRadius,
    this.borderWidth = 1.0,
    this.cardPadding = UIConstants.defaultCardPadding,
    this.sectionSpacingLarge = Spacing.lg,
    this.sectionSpacingSmall = Spacing.xxs,
    this.chipHorizontalPadding = Spacing.sm,
    this.chipVerticalPadding = Spacing.xs,
    this.tagSpacing = Spacing.sm,
    this.tagRunSpacing = Spacing.xs,
    this.locationIconSize = UIConstants.smallIconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: Spacing.sm),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline,
          width: borderWidth,
        ),
      ),
      elevation: 0,
      color: Theme.of(context).colorScheme.surface,
      child: InkWell(
        onTap: () => context.push(
          JournalRouter.journalViewPath.replaceAll(
            ':journalId',
            memoryCardModel.journalId,
          ),
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        child: Padding(
          padding: EdgeInsets.all(cardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (memoryCardModel.imageUrl != null) ...[
                ImageCard(
                  imageUrl: memoryCardModel.imageUrl!,
                  imageHeight: imageHeight,
                ),
                SizedBox(height: sectionSpacingLarge),
              ],
              _buildHeaderRow(),
              SizedBox(height: sectionSpacingSmall),
              _buildTags(),
              SizedBox(height: sectionSpacingSmall),
              _buildDescription(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Row(
      children: <Widget>[
        Text("📅${memoryCardModel.date}", style: AppTypography.labelMedium),
        const Spacer(),
        SizedBox(width: Spacing.xs),
        Text("📍${memoryCardModel.location}", style: AppTypography.labelSmall),
      ],
    );
  }

  Widget _buildTags() {
    return TagChips(
      tags: memoryCardModel.tags,
      spacing: tagSpacing,
      runSpacing: tagRunSpacing,
    );
  }

  Widget _buildDescription() {
    return Text(memoryCardModel.description, style: AppTypography.bodyLarge);
  }
}
