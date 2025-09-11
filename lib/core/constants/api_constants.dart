/// API-related constants
class ApiConstants {
  ApiConstants._();

  // ---------- Base URLs ----------
  static const String baseUrl = 'https://api.example.com';

  // ---------- Timeouts ----------
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;

  // ---------- Endpoints ----------
  static const String journalsEndpoint = '/journals';
  static const String memoriesEndpoint = '/memories';
  static const String authEndpoint = '/auth';
}
