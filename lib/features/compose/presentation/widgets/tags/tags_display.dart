import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/fonts.dart';
import 'package:my_flutter_app/core/theme/spacings.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';

class TagsDisplay extends StatelessWidget {
  final List<String> tags;
  final Function(String) onRemoveTag;

  const TagsDisplay({super.key, required this.tags, required this.onRemoveTag});

  @override
  Widget build(BuildContext context) {
    if (tags.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: Spacing.sm,
      runSpacing: Spacing.xs,
      children: tags.map((tag) => _buildTagChip(context, tag)).toList(),
    );
  }

  Widget _buildTagChip(BuildContext context, String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.sm,
        vertical: Spacing.xs,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(UIConstants.largeRadius),
        border: Border.all(
          color: Theme.of(
            context,
          ).colorScheme.primary.withValues(alpha: UIConstants.dialogOpacity),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '#$tag',
            style: AppTypography.labelSmall.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: UIConstants.tagCloseIconSpacing),
          GestureDetector(
            onTap: () => onRemoveTag(tag),
            child: Icon(
              Icons.close,
              size: UIConstants.tagCloseIconSize,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
