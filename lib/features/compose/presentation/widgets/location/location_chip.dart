import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/fonts.dart';
import 'package:my_flutter_app/core/theme/spacings.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
import 'package:my_flutter_app/features/compose/presentation/models/location_search_models.dart';

class LocationChip extends StatelessWidget {
  final LocationSearchResult location;
  final VoidCallback onRemove;

  const LocationChip({
    super.key,
    required this.location,
    required this.onRemove,
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
            location.emoji,
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
                location.name,
                style: AppTypography.labelMedium.copyWith(
                  fontSize: UIConstants.locationChipFontSize,
                ),
                softWrap: true,
              ),
            ),
          ),
          const SizedBox(width: Spacing.xs),
          GestureDetector(
            onTap: onRemove,
            child: Icon(
              Icons.close,
              size: UIConstants.locationIconSize,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
