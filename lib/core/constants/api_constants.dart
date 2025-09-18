import 'package:flutter_dotenv/flutter_dotenv.dart';

/// API-related constants
class ApiConstants {
  ApiConstants._();

  // ---------- Base URLs ----------
  static const String baseUrl = 'https://api.example.com';
  static const String googlePlacesBaseUrl =
      'https://maps.googleapis.com/maps/api/place';

  // ---------- Timeouts ----------
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;

  // ---------- Endpoints ----------
  static const String journalsEndpoint = '/journals';
  static const String memoriesEndpoint = '/memories';
  static const String authEndpoint = '/auth';

  // ---------- Google Places API ----------
  static const String placesSearchEndpoint = '/textsearch/json';
  static const String placesDetailsEndpoint = '/details/json';
  static const String placesAutocompleteEndpoint = '/autocomplete/json';

  // API Key - Loaded from environment variables
  static String get googlePlacesApiKey =>
      dotenv.env['GOOGLE_PLACES_API_KEY'] ?? '';

  // Search parameters
  static const int maxSearchResults = 20;
  static const String defaultLanguage = 'en';
  static const String defaultRegion = 'us';
}
