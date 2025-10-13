import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:my_flutter_app/core/services/google_places_service.dart';
import 'package:my_flutter_app/features/compose/presentation/models/location_search_models.dart';
import 'package:my_flutter_app/features/compose/presentation/services/location_search_service.dart';

import 'location_search_test.mocks.dart';

@GenerateMocks([GooglePlacesService])
void main() {
  group('LocationSearchService', () {
    late LocationSearchService locationSearchService;
    late MockGooglePlacesService mockGooglePlacesService;

    setUp(() {
      mockGooglePlacesService = MockGooglePlacesService();
      locationSearchService = LocationSearchService(mockGooglePlacesService);
    });

    test('should return empty list for short queries', () async {
      final results = await locationSearchService.searchLocations('a');
      expect(results, isEmpty);
    });

    test('should return mock results for valid queries', () async {
      final results = await locationSearchService.searchLocations(
        'Central Park',
      );
      expect(results, isNotEmpty);
      expect(results.first.name, contains('Central Park'));
    });
    test('should handle empty query gracefully', () async {
      final results = await locationSearchService.searchLocations('');
      expect(results, isEmpty);
    });

    test('should handle whitespace-only query gracefully', () async {
      final results = await locationSearchService.searchLocations('   ');
      expect(results, isEmpty);
    });
  });

  group('LocationSearchResult', () {
    test('should create instance with all parameters', () {
      const result = LocationSearchResult(
        id: '1',
        name: 'Test Location',
        address: 'Test Address',
        placeId: 'place_123',
        latitude: 40.7128,
        longitude: -74.0060,
        rating: 4.5,
        types: ['landmark', 'tourist_attraction'],
      );

      expect(result.id, '1');
      expect(result.name, 'Test Location');
      expect(result.address, 'Test Address');
      expect(result.placeId, 'place_123');
      expect(result.latitude, 40.7128);
      expect(result.longitude, -74.0060);
      expect(result.rating, 4.5);
      expect(result.types, ['landmark', 'tourist_attraction']);
      expect(result.displayType, 'Landmark');
      expect(result.emoji, '📸');
    });

    test('should create instance with minimal parameters', () {
      const result = LocationSearchResult(
        id: '1',
        name: 'Test Location',
        address: 'Test Address',
      );

      expect(result.id, '1');
      expect(result.name, 'Test Location');
      expect(result.address, 'Test Address');
      expect(result.placeId, isNull);
      expect(result.latitude, isNull);
      expect(result.longitude, isNull);
      expect(result.rating, isNull);
      expect(result.types, isNull);
      expect(result.displayType, 'Location');
      expect(result.emoji, '📍');
    });
  });
}
