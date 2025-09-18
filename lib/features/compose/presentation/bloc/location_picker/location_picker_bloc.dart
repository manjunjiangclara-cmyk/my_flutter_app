import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:my_flutter_app/features/compose/presentation/services/location_search_service.dart';

import 'location_picker_event.dart';
import 'location_picker_state.dart';

/// BLoC for managing location picker state and business logic
@injectable
class LocationPickerBloc
    extends Bloc<LocationPickerEvent, LocationPickerState> {
  final LocationSearchService _locationSearchService;
  Timer? _debounceTimer;

  LocationPickerBloc(this._locationSearchService)
    : super(const LocationPickerInitial()) {
    on<LocationPickerSearchRequested>(_onSearchRequested);
    on<LocationPickerLocationSelected>(_onLocationSelected);
    on<LocationPickerSearchCleared>(_onSearchCleared);
    on<LocationPickerCleared>(_onCleared);
  }

  /// Handle search request with debouncing
  Future<void> _onSearchRequested(
    LocationPickerSearchRequested event,
    Emitter<LocationPickerState> emit,
  ) async {
    // Cancel previous timer
    _debounceTimer?.cancel();

    // Return empty results for very short queries
    if (event.query.trim().length < 2) {
      emit(const LocationPickerSearchClearedState());
      return;
    }

    // Show loading state
    emit(const LocationPickerLoading());

    // Use debouncing to avoid too many API calls
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      // Check if the BLoC is still active before emitting
      if (isClosed) return;

      try {
        final results = await _locationSearchService.searchLocations(
          event.query,
        );

        // Check again before emitting results
        if (isClosed) return;

        if (results.isEmpty) {
          emit(LocationPickerNoResults(query: event.query));
        } else {
          emit(
            LocationPickerSearchResultsLoaded(
              searchResults: results,
              query: event.query,
            ),
          );
        }
      } catch (e) {
        // Check again before emitting error
        if (isClosed) return;
        emit(LocationPickerError(message: 'Failed to search locations: $e'));
      }
    });
  }

  /// Handle location selection
  void _onLocationSelected(
    LocationPickerLocationSelected event,
    Emitter<LocationPickerState> emit,
  ) {
    emit(LocationPickerLocationSelectedState(selectedLocation: event.location));
  }

  /// Handle search cleared
  void _onSearchCleared(
    LocationPickerSearchCleared event,
    Emitter<LocationPickerState> emit,
  ) {
    emit(const LocationPickerSearchClearedState());
  }

  /// Handle clear all state
  void _onCleared(
    LocationPickerCleared event,
    Emitter<LocationPickerState> emit,
  ) {
    _debounceTimer?.cancel();
    emit(const LocationPickerInitial());
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
