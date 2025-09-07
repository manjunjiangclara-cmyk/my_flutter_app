import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/colors.dart';
import 'package:my_flutter_app/core/theme/fonts.dart';
import 'package:my_flutter_app/core/theme/spacings.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';

/// A widget to display a list of tags as chips.
class TagChips extends StatelessWidget {
  final List<String> tags;

  const TagChips({required this.tags, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: tags.asMap().entries.map<Widget>((entry) {
        final index = entry.key;
        final tag = entry.value;
        return Row(
          children: [
            TagChip(tag: tag),
            if (index < tags.length - 1) SizedBox(width: Spacing.sm),
          ],
        );
      }).toList(),
    );
  }
}

class TagChip extends StatelessWidget {
  final String tag;
  final double chipHorizontalPadding;
  final double chipVerticalPadding;

  const TagChip({
    super.key,
    required this.tag,
    this.chipHorizontalPadding = Spacing.xs,
    this.chipVerticalPadding = Spacing.xs,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(tag, style: AppTypography.labelSmall),
      backgroundColor: AppColors.border.withValues(alpha: 0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UIConstants.defaultRadius),
        side: BorderSide.none,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: chipHorizontalPadding,
        vertical: chipVerticalPadding,
      ),
    );
  }
}
