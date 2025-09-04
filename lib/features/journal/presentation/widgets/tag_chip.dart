import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/colors.dart';
import 'package:my_flutter_app/core/theme/spacing.dart';
import 'package:my_flutter_app/core/theme/typography.dart';
import 'package:my_flutter_app/core/ui_constants.dart';

/// A widget to display a list of tags as chips.
class TagChips extends StatelessWidget {
  final List<String> tags;

  const TagChips({required this.tags, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: tags.map<Widget>((String tag) {
        return TagChip(tag: tag);
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
    this.chipHorizontalPadding = Spacing.sm,
    this.chipVerticalPadding = Spacing.xs,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(tag, style: AppTypography.caption),
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
