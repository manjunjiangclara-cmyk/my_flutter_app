import 'package:equatable/equatable.dart';
import 'package:my_flutter_app/features/compose/presentation/models/location_search_models.dart';

/// Events for LocationPickerBloc
abstract class LocationPickerEvent extends Equatable {
  const LocationPickerEvent();

  @override
  List<Object?> get props => [];
}

/// Event to search for locations
class LocationPickerSearchRequested extends LocationPickerEvent {
  final String query;

  const LocationPickerSearchRequested(this.query);

  @override
  List<Object?> get props => [query];
}

/// Event when a location is selected
class LocationPickerLocationSelected extends LocationPickerEvent {
  final LocationSearchResult location;

  const LocationPickerLocationSelected(this.location);

  @override
  List<Object?> get props => [location];
}

/// Event to clear search
class LocationPickerSearchCleared extends LocationPickerEvent {
  const LocationPickerSearchCleared();
}

/// Event to clear all state
class LocationPickerCleared extends LocationPickerEvent {
  const LocationPickerCleared();
}
