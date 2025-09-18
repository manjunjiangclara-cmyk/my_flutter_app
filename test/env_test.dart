import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_app/core/constants/api_constants.dart';

void main() {
  group('Environment Variables', () {
    setUpAll(() async {
      // Load environment variables for testing
      await dotenv.load(fileName: ".env");
    });

    test('should load Google Places API key from environment', () {
      final apiKey = dotenv.env['GOOGLE_PLACES_API_KEY'];
      expect(apiKey, isNotNull);
      expect(apiKey, isNotEmpty);
      expect(apiKey, startsWith('AIza'));
    });

    test('should get API key through ApiConstants', () {
      final apiKey = ApiConstants.googlePlacesApiKey;
      expect(apiKey, isNotNull);
      expect(apiKey, isNotEmpty);
      expect(apiKey, startsWith('AIza'));
    });

    test('should handle missing environment variable gracefully', () {
      // Test with a non-existent key
      final missingKey = dotenv.env['NON_EXISTENT_KEY'];
      expect(missingKey, isNull);
    });

    test('should have correct API base URL', () {
      expect(
        ApiConstants.googlePlacesBaseUrl,
        'https://maps.googleapis.com/maps/api/place',
      );
    });

    test('should have correct search parameters', () {
      expect(ApiConstants.maxSearchResults, 20);
      expect(ApiConstants.defaultLanguage, 'en');
      expect(ApiConstants.defaultRegion, 'us');
    });
  });
}
