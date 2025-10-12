import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/fonts.dart';
import 'package:my_flutter_app/core/theme/spacings.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
import 'package:my_flutter_app/features/compose/presentation/models/location_search_models.dart';

class LocationSearchResultItem extends StatelessWidget {
  final LocationSearchResult location;
  final VoidCallback onTap;
  final bool isSelected;

  const LocationSearchResultItem({
    super.key,
    required this.location,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(UIConstants.defaultRadius),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: UIConstants.defaultPadding,
            vertical: Spacing.md,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(
                    context,
                  ).colorScheme.primaryContainer.withValues(alpha: 0.3)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(UIConstants.defaultRadius),
          ),
          child: Row(
            children: [
              // Location details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      location.name,
                      style: AppTypography.bodyLarge.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: Spacing.xs),
                    Text(
                      location.address,
                      style: AppTypography.bodyMedium.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: Spacing.xs),
                    Row(
                      children: [
                        Text(
                          location.type.displayName,
                          style: AppTypography.labelSmall.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (location.rating != null) ...[
                          const SizedBox(width: Spacing.sm),
                          Icon(
                            Icons.star,
                            size: UIConstants.locationRatingIconSize,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: Spacing.xs),
                          Text(
                            location.rating!.toStringAsFixed(1),
                            style: AppTypography.labelSmall.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              // Selection indicator
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  size: UIConstants.defaultIconSize,
                  color: Theme.of(context).colorScheme.primary,
                )
              else
                Icon(
                  Icons.arrow_forward_ios,
                  size: UIConstants.smallIconSize,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getLocationIcon() {
    switch (location.type) {
      case LocationType.city:
        return Icons.location_city;
      case LocationType.landmark:
        return Icons.place;
      case LocationType.business:
        return Icons.store;
      case LocationType.neighborhood:
        return Icons.home;
    }
  }
}
