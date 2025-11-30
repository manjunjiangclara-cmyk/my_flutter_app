import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_flutter_app/core/strings.dart';
import 'package:my_flutter_app/core/theme/fonts.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
import 'package:my_flutter_app/features/compose/presentation/bloc/location_picker/location_picker_bloc.dart';
import 'package:my_flutter_app/features/compose/presentation/bloc/location_picker/location_picker_event.dart';
import 'package:my_flutter_app/features/compose/presentation/bloc/location_picker/location_picker_state.dart';
import 'package:my_flutter_app/features/compose/presentation/models/location_search_models.dart';
import 'package:my_flutter_app/features/compose/presentation/widgets/location/location_search_result_item.dart';
import 'package:my_flutter_app/shared/presentation/widgets/base_bottom_sheet.dart';
import 'package:my_flutter_app/shared/presentation/widgets/refresh_indicator.dart';
import 'package:my_flutter_app/shared/presentation/widgets/search_bar.dart';
import 'package:my_flutter_app/shared/presentation/widgets/section_divider.dart';

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
    return BaseBottomSheet(
      title: AppStrings.locationPickerTitle,
      height:
          MediaQuery.of(context).size.height * UIConstants.locationPickerHeight,
      closeButtonIconSize: UIConstants.datePickerCloseButtonIconSize,
      contentPadding: EdgeInsets.zero,
      child: Column(
        children: [
          // Search bar
          UniversalSearchBar(
            hintText: AppStrings.locationSearchHint,
            onSearchChanged: _onSearchChanged,
            onClearSearch: _clearSearch,
            padding: EdgeInsets.zero,
          ),
          SizedBox(height: UIConstants.smallPadding),
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
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.primary,
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
            const SizedBox(height: UIConstants.mediumSpacing),
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
            vertical: UIConstants.smallPadding,
            horizontal: UIConstants.defaultPadding,
          ),
          itemCount: state.searchResults.length,
          itemBuilder: (context, index) {
            final location = state.searchResults[index];
            final isLast = index == state.searchResults.length - 1;

            return Column(
              children: [
                LocationSearchResultItem(
                  location: location,
                  onTap: () => _onLocationSelected(location),
                ),
                if (!isLast) const SectionDivider(),
              ],
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
            const SizedBox(height: UIConstants.mediumSpacing),
            Text(
              AppStrings.noLocationsFound,
              style: AppTypography.bodyLarge.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: UIConstants.extraSmallPadding),
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
