import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:my_flutter_app/core/strings.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
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
    on<LocationPickerSearchExecute>(_onSearchExecute);
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

    // Debounce by scheduling an internal execute event
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (isClosed) return;
      add(LocationPickerSearchExecute(event.query));
    });
  }

  /// Execute the debounced search (safe to emit here)
  Future<void> _onSearchExecute(
    LocationPickerSearchExecute event,
    Emitter<LocationPickerState> emit,
  ) async {
    try {
      final results = await _locationSearchService
          .searchLocations(event.query)
          .timeout(UIConstants.locationSearchTimeout);

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
    } on TimeoutException {
      emit(
        const LocationPickerError(message: AppStrings.locationSearchTimeout),
      );
    } catch (e) {
      emit(
        LocationPickerError(message: '${AppStrings.locationSearchError}: $e'),
      );
    }
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
