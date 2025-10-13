import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/fonts.dart';
import 'package:my_flutter_app/core/theme/spacings.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';

/// A read-only location chip used to display an emoji and a location name.
/// This mirrors the compose `LocationChip` visual style but without the remove button.
class LocationChipDisplay extends StatelessWidget {
  final String emoji;
  final String name;

  const LocationChipDisplay({
    super.key,
    required this.emoji,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    final maxWidth =
        MediaQuery.of(context).size.width *
        UIConstants.locationChipMaxWidthFraction;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: UIConstants.locationChipHorizontalPadding,
        vertical: UIConstants.locationChipVerticalPadding,
      ),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.outline.withValues(alpha: UIConstants.dialogOpacity),
        borderRadius: BorderRadius.circular(UIConstants.locationChipRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            emoji,
            style: AppTypography.labelMedium.copyWith(
              fontSize:
                  UIConstants.locationChipFontSize *
                  UIConstants.locationEmojiScale,
            ),
          ),
          const SizedBox(width: Spacing.xs),
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Text(
                name,
                style: AppTypography.labelMedium.copyWith(
                  fontSize: UIConstants.locationChipFontSize,
                ),
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
