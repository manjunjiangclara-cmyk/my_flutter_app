import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:my_flutter_app/core/constants/api_constants.dart';
import 'package:my_flutter_app/features/compose/presentation/models/location_search_models.dart';

/// Service for interacting with Google Places API
@singleton
class GooglePlacesService {
  GooglePlacesService();

  /// Search for places using Google Places Text Search API
  Future<List<GooglePlaceResult>> searchPlaces(String query) async {
    if (query.trim().isEmpty) return [];

    try {
      final uri = Uri.parse(
        '${ApiConstants.googlePlacesBaseUrl}${ApiConstants.placesSearchEndpoint}'
        '?query=${Uri.encodeComponent(query)}'
        '&key=${ApiConstants.googlePlacesApiKey}'
        '&language=${ApiConstants.defaultLanguage}'
        '&region=${ApiConstants.defaultRegion}',
      );

      final response = await http
          .get(uri, headers: {'Content-Type': 'application/json'})
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _parseSearchResults(data);
      } else {
        throw GooglePlacesException(
          'API request failed: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw GooglePlacesException('Failed to search places: $e');
    }
  }

  /// Get place details using Google Places Details API
  Future<GooglePlaceDetails?> getPlaceDetails(String placeId) async {
    try {
      final uri = Uri.parse(
        '${ApiConstants.googlePlacesBaseUrl}${ApiConstants.placesDetailsEndpoint}'
        '?place_id=$placeId'
        '&key=${ApiConstants.googlePlacesApiKey}'
        '&fields=place_id,name,formatted_address,geometry,types,rating,photos',
      );

      final response = await http
          .get(uri, headers: {'Content-Type': 'application/json'})
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _parsePlaceDetails(data);
      } else {
        throw GooglePlacesException(
          'API request failed: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw GooglePlacesException('Failed to get place details: $e');
    }
  }

  /// Parse search results from Google Places API response
  List<GooglePlaceResult> _parseSearchResults(Map<String, dynamic> data) {
    if (data['status'] != 'OK') {
      throw GooglePlacesException('API returned status: ${data['status']}');
    }

    final results = data['results'] as List<dynamic>? ?? [];
    return results
        .take(ApiConstants.maxSearchResults)
        .map((result) => GooglePlaceResult.fromJson(result))
        .toList();
  }

  /// Parse place details from Google Places API response
  GooglePlaceDetails? _parsePlaceDetails(Map<String, dynamic> data) {
    if (data['status'] != 'OK') {
      throw GooglePlacesException('API returned status: ${data['status']}');
    }

    final result = data['result'];
    if (result == null) return null;

    return GooglePlaceDetails.fromJson(result);
  }
}

/// Google Place search result model
class GooglePlaceResult {
  final String placeId;
  final String name;
  final String formattedAddress;
  final double? rating;
  final List<String> types;
  final GooglePlaceGeometry? geometry;
  final List<GooglePlacePhoto>? photos;

  const GooglePlaceResult({
    required this.placeId,
    required this.name,
    required this.formattedAddress,
    this.rating,
    required this.types,
    this.geometry,
    this.photos,
  });

  factory GooglePlaceResult.fromJson(Map<String, dynamic> json) {
    return GooglePlaceResult(
      placeId: json['place_id'] ?? '',
      name: json['name'] ?? '',
      formattedAddress: json['formatted_address'] ?? '',
      rating: json['rating']?.toDouble(),
      types: (json['types'] as List<dynamic>?)?.cast<String>() ?? [],
      geometry: json['geometry'] != null
          ? GooglePlaceGeometry.fromJson(json['geometry'])
          : null,
      photos: (json['photos'] as List<dynamic>?)
          ?.map((photo) => GooglePlacePhoto.fromJson(photo))
          .toList(),
    );
  }

  /// Convert to LocationSearchResult for compatibility
  LocationSearchResult toLocationSearchResult() {
    return LocationSearchResult(
      id: placeId,
      name: name,
      address: formattedAddress,
      placeId: placeId,
      latitude: geometry?.location.latitude,
      longitude: geometry?.location.longitude,
      rating: rating,
      types: types,
    );
  }
}

/// Google Place details model
class GooglePlaceDetails {
  final String placeId;
  final String name;
  final String formattedAddress;
  final double? rating;
  final List<String> types;
  final GooglePlaceGeometry? geometry;
  final List<GooglePlacePhoto>? photos;

  const GooglePlaceDetails({
    required this.placeId,
    required this.name,
    required this.formattedAddress,
    this.rating,
    required this.types,
    this.geometry,
    this.photos,
  });

  factory GooglePlaceDetails.fromJson(Map<String, dynamic> json) {
    return GooglePlaceDetails(
      placeId: json['place_id'] ?? '',
      name: json['name'] ?? '',
      formattedAddress: json['formatted_address'] ?? '',
      rating: json['rating']?.toDouble(),
      types: (json['types'] as List<dynamic>?)?.cast<String>() ?? [],
      geometry: json['geometry'] != null
          ? GooglePlaceGeometry.fromJson(json['geometry'])
          : null,
      photos: (json['photos'] as List<dynamic>?)
          ?.map((photo) => GooglePlacePhoto.fromJson(photo))
          .toList(),
    );
  }
}

/// Google Place geometry model
class GooglePlaceGeometry {
  final GooglePlaceLocation location;

  const GooglePlaceGeometry({required this.location});

  factory GooglePlaceGeometry.fromJson(Map<String, dynamic> json) {
    return GooglePlaceGeometry(
      location: GooglePlaceLocation.fromJson(json['location']),
    );
  }
}

/// Google Place location model
class GooglePlaceLocation {
  final double latitude;
  final double longitude;

  const GooglePlaceLocation({required this.latitude, required this.longitude});

  factory GooglePlaceLocation.fromJson(Map<String, dynamic> json) {
    return GooglePlaceLocation(
      latitude: json['lat']?.toDouble() ?? 0.0,
      longitude: json['lng']?.toDouble() ?? 0.0,
    );
  }
}

/// Google Place photo model
class GooglePlacePhoto {
  final String photoReference;
  final int? height;
  final int? width;

  const GooglePlacePhoto({
    required this.photoReference,
    this.height,
    this.width,
  });

  factory GooglePlacePhoto.fromJson(Map<String, dynamic> json) {
    return GooglePlacePhoto(
      photoReference: json['photo_reference'] ?? '',
      height: json['height'],
      width: json['width'],
    );
  }

  /// Get photo URL
  String getPhotoUrl(String apiKey, {int maxWidth = 400}) {
    return 'https://maps.googleapis.com/maps/api/place/photo'
        '?maxwidth=$maxWidth'
        '&photo_reference=$photoReference'
        '&key=$apiKey';
  }
}

/// Google Places API exception
class GooglePlacesException implements Exception {
  final String message;
  GooglePlacesException(this.message);

  @override
  String toString() => 'GooglePlacesException: $message';
}
