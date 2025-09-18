import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:my_flutter_app/core/services/google_places_service.dart';
import 'package:my_flutter_app/features/compose/presentation/models/location_search_models.dart';

/// Service for searching locations using Google Places API
@injectable
class LocationSearchService {
  final GooglePlacesService _googlePlacesService;

  LocationSearchService(this._googlePlacesService);

  Timer? _debounceTimer;

  /// Search for locations using Google Places API with debouncing
  Future<List<LocationSearchResult>> searchLocations(String query) async {
    // Cancel previous timer
    _debounceTimer?.cancel();

    // Return empty list for very short queries
    if (query.trim().length < 2) {
      return [];
    }

    // Use a completer to handle debouncing
    final completer = Completer<List<LocationSearchResult>>();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      try {
        final googleResults = await _googlePlacesService.searchPlaces(query);
        final results = googleResults
            .map((result) => result.toLocationSearchResult())
            .toList();
        completer.complete(results);
      } catch (e) {
        completer.complete([]);
      }
    });

    return completer.future;
  }

  /// Dispose resources
  void dispose() {
    _debounceTimer?.cancel();
  }
}
