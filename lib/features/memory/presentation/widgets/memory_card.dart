import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:my_flutter_app/core/strings.dart';
import 'package:my_flutter_app/core/theme/fonts.dart';
import 'package:my_flutter_app/core/theme/spacings.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
import 'package:my_flutter_app/core/utils/date_formatter.dart';
import 'package:my_flutter_app/features/compose/presentation/models/place_types.dart';
import 'package:my_flutter_app/features/journal/presentation/router/journal_router.dart';
import 'package:my_flutter_app/features/journal/presentation/widgets/image_card.dart';
import 'package:my_flutter_app/features/memory/presentation/models/memory_card_model.dart';
import 'package:my_flutter_app/shared/presentation/widgets/location_chip_display.dart';
import 'package:my_flutter_app/shared/presentation/widgets/tag_chip.dart';

class MemoryCard extends StatefulWidget {
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
    this.borderRadius = UIConstants.imageCardRadius,
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
  State<MemoryCard> createState() => _MemoryCardState();
}

class _MemoryCardState extends State<MemoryCard>
    with AutomaticKeepAliveClientMixin {
  bool _isPressed = false;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final double scale = _isPressed ? UIConstants.memoryCardPressScale : 1.0;

    return AnimatedScale(
      scale: scale,
      duration: UIConstants.memoryCardPressDuration,
      curve: Curves.easeOutCubic,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: Spacing.sm),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          color: Theme.of(context).brightness == Brightness.dark
              ? Color.lerp(
                  Theme.of(context).colorScheme.surface,
                  Colors.white,
                  UIConstants.memoryCardDarkLightenAmount,
                )!
              : Theme.of(context).colorScheme.surface,
          border: Border.all(
            color: Theme.of(context).colorScheme.outline,
            width: widget.borderWidth,
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow.withOpacity(0.08),
              blurRadius: 12.0,
              spreadRadius: 0.0,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow.withOpacity(0.08),
              blurRadius: 8.0,
              spreadRadius: 0.0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            context.push(
              JournalRouter.journalViewPath.replaceAll(
                ':journalId',
                widget.memoryCardModel.journalId,
              ),
            );
          },
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapCancel: () => setState(() => _isPressed = false),
          onTapUp: (_) => setState(() => _isPressed = false),
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: Padding(
            padding: EdgeInsets.all(widget.cardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (widget.memoryCardModel.imagePaths.isNotEmpty) ...[
                  ImageCard(
                    imagePath: widget.memoryCardModel.imagePaths.first,
                    imageHeight: widget.imageHeight,
                  ),
                  SizedBox(height: widget.sectionSpacingLarge),
                ],
                _buildHeaderRow(),
                SizedBox(height: widget.sectionSpacingSmall),
                _buildTags(),
                SizedBox(height: widget.sectionSpacingSmall),
                _buildDescription(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Row(
      children: <Widget>[
        Text(
          DateFormatter.formatDate(
            widget.memoryCardModel.date,
            format: AppStrings.memoryCardDateFormat,
          ),
          style: AppTypography.labelMedium,
        ),
        const Spacer(),
        SizedBox(width: Spacing.xs),
        if (widget.memoryCardModel.location != null && widget.memoryCardModel.location!.isNotEmpty)
          LocationChipDisplay(
            emoji: emojiForLocation(
              types: widget.memoryCardModel.locationTypes,
              locationName: widget.memoryCardModel.location!,
            ),
            name: widget.memoryCardModel.location!,
          ),
      ],
    );
  }

  Widget _buildTags() {
    return TagChips(
      tags: widget.memoryCardModel.tags,
      spacing: widget.tagSpacing,
      runSpacing: widget.tagRunSpacing,
    );
  }

  Widget _buildDescription() {
    return Text(
      widget.memoryCardModel.description,
      style: AppTypography.bodyLarge,
    );
  }
}
