import 'place_types.dart';

/// Location search result model
class LocationSearchResult {
  final String id;
  final String name;
  final String address;
  final String? placeId;
  final double? latitude;
  final double? longitude;
  final double? rating;
  final List<String>? types;

  const LocationSearchResult({
    required this.id,
    required this.name,
    required this.address,
    this.placeId,
    this.latitude,
    this.longitude,
    this.rating,
    this.types,
  });

  /// Get the emoji for this location based on its types
  String get emoji => emojiForTypes(types ?? []);

  /// Get a display-friendly type name based on the primary type
  String get displayType {
    if (types == null || types!.isEmpty) return 'Location';

    // Return the first type, formatted nicely
    final primaryType = types!.first;
    return primaryType
        .split('_')
        .map(
          (word) =>
              word.isEmpty ? word : word[0].toUpperCase() + word.substring(1),
        )
        .join(' ');
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LocationSearchResult && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'LocationSearchResult(id: $id, name: $name, address: $address, types: $types, placeId: $placeId, lat: $latitude, lng: $longitude)';
}
