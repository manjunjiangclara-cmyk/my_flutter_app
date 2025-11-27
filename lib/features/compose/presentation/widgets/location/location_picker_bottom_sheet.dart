import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:my_flutter_app/core/strings.dart';
import 'package:my_flutter_app/core/theme/fonts.dart';
import 'package:my_flutter_app/core/theme/spacings.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
import 'package:my_flutter_app/features/compose/presentation/bloc/location_picker/location_picker_bloc.dart';
import 'package:my_flutter_app/features/compose/presentation/bloc/location_picker/location_picker_event.dart';
import 'package:my_flutter_app/features/compose/presentation/bloc/location_picker/location_picker_state.dart';
import 'package:my_flutter_app/features/compose/presentation/models/location_search_models.dart';
import 'package:my_flutter_app/features/compose/presentation/widgets/location/location_search_result_item.dart';
import 'package:my_flutter_app/shared/presentation/widgets/refresh_indicator.dart';
import 'package:my_flutter_app/shared/presentation/widgets/search_bar.dart';

class LocationPickerBottomSheet extends StatefulWidget {
  final Function(LocationSearchResult) onLocationSelected;

  const LocationPickerBottomSheet({
    super.key,
    required this.onLocationSelected,
  });

  @override
  State<LocationPickerBottomSheet> createState() =>
      _LocationPickerBottomSheetState();
}

class _LocationPickerBottomSheetState extends State<LocationPickerBottomSheet> {
  void _onSearchChanged(String query) {
    if (query.trim().isEmpty) {
      context.read<LocationPickerBloc>().add(
        const LocationPickerSearchCleared(),
      );
      return;
    }

    context.read<LocationPickerBloc>().add(
      LocationPickerSearchRequested(query),
    );
  }

  Future<void> _onRefresh() async {
    final bloc = context.read<LocationPickerBloc>();
    final state = bloc.state;
    String? query;

    if (state is LocationPickerSearchResultsLoaded) {
      query = state.query;
    } else if (state is LocationPickerNoResults) {
      query = state.query;
    }

    if (query != null && query.trim().isNotEmpty) {
      bloc.add(LocationPickerSearchRequested(query));
    }
  }

  void _onLocationSelected(LocationSearchResult location) {
    // Provide light haptic feedback
    HapticFeedback.lightImpact();

    context.read<LocationPickerBloc>().add(
      LocationPickerLocationSelected(location),
    );
    widget.onLocationSelected(location);
    Navigator.of(context).pop();
  }

  void _clearSearch() {
    context.read<LocationPickerBloc>().add(const LocationPickerSearchCleared());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height:
          MediaQuery.of(context).size.height * UIConstants.locationPickerHeight,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(UIConstants.locationPickerCornerRadius),
          topRight: Radius.circular(UIConstants.locationPickerCornerRadius),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: Spacing.md),
            width: UIConstants.bottomSheetHandleWidth,
            height: UIConstants.bottomSheetHandleHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                UIConstants.bottomSheetHandleRadius,
              ),
            ),
          ),

          // Title
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: UIConstants.defaultPadding,
              vertical: Spacing.md,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppStrings.locationPickerTitle,
                style: AppTypography.labelMedium.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ),

          // Search bar
          UniversalSearchBar(
            hintText: AppStrings.locationSearchHint,
            onSearchChanged: _onSearchChanged,
            onClearSearch: _clearSearch,
          ),

          // Content with gradient overlay
          Expanded(
            child: Stack(
              children: [
                BlocBuilder<LocationPickerBloc, LocationPickerState>(
                  builder: (context, state) {
                    return _buildContent(state);
                  },
                ),
                // Gradient overlay at the top of results
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: UIConstants.locationPickerGradientHeight,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Theme.of(context).colorScheme.surface.withOpacity(
                            UIConstants.locationPickerGradientOpacity,
                          ),
                          Theme.of(
                            context,
                          ).colorScheme.surface.withOpacity(0.0),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(LocationPickerState state) {
    if (state is LocationPickerLoading) {
      return Center(
        child: SpinKitRing(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      );
    }

    if (state is LocationPickerError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: UIConstants.largeIconSize,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: Spacing.md),
            Text(
              'Error: ${state.message}',
              style: AppTypography.bodyLarge.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (state is LocationPickerSearchResultsLoaded) {
      return AppRefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(
            horizontal: UIConstants.defaultPadding,
          ),
          itemCount: state.searchResults.length,
          itemBuilder: (context, index) {
            final location = state.searchResults[index];
            return LocationSearchResultItem(
              location: location,
              onTap: () => _onLocationSelected(location),
            );
          },
        ),
      );
    }

    if (state is LocationPickerNoResults) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: UIConstants.largeIconSize,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: Spacing.md),
            Text(
              AppStrings.noLocationsFound,
              style: AppTypography.bodyLarge.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: Spacing.xs),
            Text(
              AppStrings.tryDifferentLocation,
              style: AppTypography.bodyMedium.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    // Default empty state
    return const SizedBox.shrink();
  }
}
