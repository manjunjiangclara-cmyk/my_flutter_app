import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/fonts.dart';
import 'package:my_flutter_app/core/theme/spacings.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';

class LocationChip extends StatelessWidget {
  final String location;
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
          Icon(
            Icons.location_on,
            size: UIConstants.locationIconSize,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: Spacing.xs),
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Text(
                location,
                style: AppTypography.labelMedium,
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
