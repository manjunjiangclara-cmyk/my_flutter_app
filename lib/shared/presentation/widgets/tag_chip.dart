import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/fonts.dart';
import 'package:my_flutter_app/core/theme/spacings.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
import 'package:my_flutter_app/core/utils/tag_color_utils.dart';

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
  final Function(String)? onRemoveTag;

  const TagChip({super.key, required this.tag, this.onRemoveTag});

  @override
  Widget build(BuildContext context) {
    final tagColor = TagColorUtils.getTagColor(tag);
    final onSurfaceColor = Theme.of(context).colorScheme.onSurface;

    return onRemoveTag != null
        ? _buildInteractiveChip(context, tagColor, onSurfaceColor)
        : _buildReadOnlyChip(context, tagColor, onSurfaceColor);
  }

  Widget _buildInteractiveChip(
    BuildContext context,
    Color tagColor,
    Color onSurfaceColor,
  ) {
    // Blend tag color with onSurface color for better readability
    final blendedColor = Color.lerp(tagColor, onSurfaceColor, 0.3) ?? tagColor;

    return Container(
      decoration: BoxDecoration(
        color: tagColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(UIConstants.locationChipRadius),
        border: Border.all(
          color: blendedColor.withValues(alpha: 0.2),
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTagText(tagColor, onSurfaceColor, isInteractive: true),
          const SizedBox(width: UIConstants.tagCloseIconSpacing),
          _buildCloseButton(tagColor, onSurfaceColor),
        ],
      ),
    );
  }

  Widget _buildReadOnlyChip(
    BuildContext context,
    Color tagColor,
    Color onSurfaceColor,
  ) {
    // Blend tag color with onSurface color for better readability
    final blendedColor = Color.lerp(tagColor, onSurfaceColor, 0.3) ?? tagColor;

    return Container(
      decoration: BoxDecoration(
        color: tagColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(UIConstants.locationChipRadius),
        border: Border.all(
          color: blendedColor.withValues(alpha: 0.2),
          width: 1.0,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: UIConstants.tagChipInteractiveHorizontalPadding,
          vertical: UIConstants.tagChipInteractiveVerticalPadding,
        ),
        child: _buildTagText(tagColor, onSurfaceColor, isInteractive: false),
      ),
    );
  }

  Widget _buildTagText(
    Color tagColor,
    Color onSurfaceColor, {
    required bool isInteractive,
  }) {
    // Blend tag color with onSurface color for better readability
    final blendedColor = Color.lerp(tagColor, onSurfaceColor, 0.3) ?? tagColor;
    final textStyle = AppTypography.labelSmall.copyWith(color: blendedColor);

    if (isInteractive) {
      return Padding(
        padding: EdgeInsets.only(
          left: UIConstants.tagChipInteractiveHorizontalPadding,
          top: UIConstants.tagChipInteractiveVerticalPadding,
          bottom: UIConstants.tagChipInteractiveVerticalPadding,
        ),
        child: Text(tag, style: textStyle),
      );
    }

    return Text(tag, style: textStyle);
  }

  Widget _buildCloseButton(Color tagColor, Color onSurfaceColor) {
    // Blend tag color with onSurface color for better readability
    final blendedColor = Color.lerp(tagColor, onSurfaceColor, 0.3) ?? tagColor;

    return Padding(
      padding: EdgeInsets.only(
        right: UIConstants.tagChipInteractiveVerticalPadding,
        top: UIConstants.tagChipInteractiveVerticalPadding,
        bottom: UIConstants.tagChipInteractiveVerticalPadding,
      ),
      child: GestureDetector(
        onTap: () => onRemoveTag!(tag),
        child: Icon(
          Icons.close,
          size: UIConstants.tagCloseIconSize,
          color: blendedColor,
        ),
      ),
    );
  }
}
