import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/colors.dart';
import 'package:my_flutter_app/core/theme/fonts.dart';
import 'package:my_flutter_app/core/theme/spacings.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';

class LocationDisplay extends StatelessWidget {
  final String location;
  final VoidCallback onRemove;

  const LocationDisplay({
    super.key,
    required this.location,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Spacing.sm),
      decoration: BoxDecoration(
        color: AppColors.border.withValues(alpha: UIConstants.dialogOpacity),
        borderRadius: BorderRadius.circular(UIConstants.defaultRadius),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.location_on,
            size: UIConstants.locationIconSize,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: Spacing.xs),
          Expanded(child: Text(location, style: AppTypography.labelMedium)),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(
              Icons.close,
              size: UIConstants.locationIconSize,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
