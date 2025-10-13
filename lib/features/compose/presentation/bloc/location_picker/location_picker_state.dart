import 'package:equatable/equatable.dart';
import 'package:my_flutter_app/features/compose/presentation/models/location_search_models.dart';

/// States for LocationPickerBloc
abstract class LocationPickerState extends Equatable {
  const LocationPickerState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class LocationPickerInitial extends LocationPickerState {
  const LocationPickerInitial();
}

/// Loading state
class LocationPickerLoading extends LocationPickerState {
  const LocationPickerLoading();
}

/// State when search results are loaded
class LocationPickerSearchResultsLoaded extends LocationPickerState {
  final List<LocationSearchResult> searchResults;
  final String query;

  const LocationPickerSearchResultsLoaded({
    required this.searchResults,
    required this.query,
  });

  @override
  List<Object?> get props => [searchResults, query];
}

/// State when search is cleared
class LocationPickerSearchClearedState extends LocationPickerState {
  const LocationPickerSearchClearedState();
}

/// State when no results are found
class LocationPickerNoResults extends LocationPickerState {
  final String query;

  const LocationPickerNoResults({required this.query});

  @override
  List<Object?> get props => [query];
}

/// State when an error occurs
class LocationPickerError extends LocationPickerState {
  final String message;

  const LocationPickerError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// State when a location is selected
class LocationPickerLocationSelectedState extends LocationPickerState {
  final LocationSearchResult selectedLocation;

  const LocationPickerLocationSelectedState({required this.selectedLocation});

  @override
  List<Object?> get props => [selectedLocation];
}
