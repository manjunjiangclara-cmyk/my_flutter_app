import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_flutter_app/core/strings.dart';
import 'package:my_flutter_app/core/theme/fonts.dart';
import 'package:my_flutter_app/core/theme/spacings.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
import 'package:my_flutter_app/features/compose/presentation/bloc/location_picker/location_picker_bloc.dart';
import 'package:my_flutter_app/features/compose/presentation/bloc/location_picker/location_picker_event.dart';
import 'package:my_flutter_app/features/compose/presentation/bloc/location_picker/location_picker_state.dart';
import 'package:my_flutter_app/features/compose/presentation/models/location_search_models.dart';
import 'package:my_flutter_app/features/compose/presentation/widgets/location/location_search_result_item.dart';

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
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Auto-focus search field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

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

  void _onLocationSelected(LocationSearchResult location) {
    context.read<LocationPickerBloc>().add(
      LocationPickerLocationSelected(location),
    );
    widget.onLocationSelected(location);
    Navigator.of(context).pop();
  }

  void _clearSearch() {
    _searchController.clear();
    _searchFocusNode.requestFocus();
    context.read<LocationPickerBloc>().add(const LocationPickerSearchCleared());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height:
          MediaQuery.of(context).size.height * UIConstants.locationPickerHeight,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(UIConstants.largeRadius),
          topRight: Radius.circular(UIConstants.largeRadius),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: Spacing.md),
            width: UIConstants.locationPickerHandleWidth,
            height: UIConstants.locationPickerHandleHeight,
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(UIConstants.defaultPadding),
            child: Row(
              children: [
                Text(
                  AppStrings.addLocation,
                  style: AppTypography.headlineMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                  iconSize: UIConstants.defaultIconSize,
                ),
              ],
            ),
          ),

          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: UIConstants.defaultPadding,
            ),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              decoration: InputDecoration(
                hintText: AppStrings.locationSearchHint,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        onPressed: _clearSearch,
                        icon: const Icon(Icons.clear),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    UIConstants.defaultRadius,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: UIConstants.defaultPadding,
                  vertical: Spacing.md,
                ),
              ),
              onChanged: _onSearchChanged,
              textInputAction: TextInputAction.search,
            ),
          ),

          const SizedBox(height: Spacing.lg),

          // Content
          Expanded(
            child: BlocBuilder<LocationPickerBloc, LocationPickerState>(
              builder: (context, state) {
                return _buildContent(state);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(LocationPickerState state) {
    if (state is LocationPickerLoading) {
      return const Center(child: CircularProgressIndicator());
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
      return ListView.builder(
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
