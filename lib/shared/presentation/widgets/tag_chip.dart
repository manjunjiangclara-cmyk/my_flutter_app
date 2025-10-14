import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/fonts.dart';
import 'package:my_flutter_app/core/theme/spacings.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';

/// A widget to display a list of tags as chips.
class TagChips extends StatelessWidget {
  final List<String> tags;
  final double spacing;
  final double runSpacing;
  final Function(String)? onRemoveTag;

  const TagChips({
    required this.tags,
    this.spacing = Spacing.sm,
    this.runSpacing = Spacing.xs,
    this.onRemoveTag,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (tags.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      children: [
        ...tags.map<Widget>(
          (tag) => TagChip(tag: tag, onRemoveTag: onRemoveTag),
        ),
      ],
    );
  }
}

class TagChip extends StatelessWidget {
  final String tag;
  final double chipHorizontalPadding;
  final double chipVerticalPadding;
  final Function(String)? onRemoveTag;

  const TagChip({
    super.key,
    required this.tag,
    this.chipHorizontalPadding = 8.0,
    this.chipVerticalPadding = 4.0,
    this.onRemoveTag,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    if (onRemoveTag != null) {
      // Interactive chip with close button
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: chipHorizontalPadding,
          vertical: chipVerticalPadding,
        ),
        decoration: BoxDecoration(
          color: primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(UIConstants.locationChipRadius),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              tag,
              style: AppTypography.labelMedium.copyWith(
                color: primary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: UIConstants.tagCloseIconSpacing),
            GestureDetector(
              onTap: () => onRemoveTag!(tag),
              child: Icon(
                Icons.close,
                size: UIConstants.tagCloseIconSize,
                color: primary,
              ),
            ),
          ],
        ),
      );
    } else {
      // Read-only chip using Material Chip widget with primary outline
      return Chip(
        label: Text(
          tag,
          style: AppTypography.labelMedium.copyWith(color: primary),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UIConstants.locationChipRadius),
          side: BorderSide(color: primary), // Primary color outline
        ),
        padding: EdgeInsets.symmetric(
          horizontal: chipHorizontalPadding,
          vertical: chipVerticalPadding,
        ),
      );
    }
  }
}
