import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/fonts.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
import 'package:my_flutter_app/features/compose/presentation/models/location_search_models.dart';
import 'package:my_flutter_app/features/compose/presentation/models/place_types.dart';
import 'package:my_flutter_app/shared/presentation/widgets/trailing_chevron.dart';

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
            vertical: UIConstants.smallSpacing,
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (location.types != null &&
                            location.types!.isNotEmpty) ...[
                          Text(
                            emojiForTypes(location.types!),
                            style: AppTypography.labelLarge,
                          ),
                          const SizedBox(width: UIConstants.extraSmallPadding),
                        ],
                        Expanded(
                          child: Text(
                            location.name,
                            style: AppTypography.bodyLarge.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: UIConstants.extraSmallPadding),
                    Text(
                      location.address,
                      style: AppTypography.labelSmall.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: UIConstants.extraSmallPadding),
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
                const TrailingChevron(),
            ],
          ),
        ),
      ),
    );
  }
}
