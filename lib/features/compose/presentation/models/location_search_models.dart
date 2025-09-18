/// Location search result model
class LocationSearchResult {
  final String id;
  final String name;
  final String address;
  final LocationType type;
  final String? placeId;
  final double? latitude;
  final double? longitude;
  final double? rating;
  final List<String>? types;

  const LocationSearchResult({
    required this.id,
    required this.name,
    required this.address,
    required this.type,
    this.placeId,
    this.latitude,
    this.longitude,
    this.rating,
    this.types,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LocationSearchResult && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'LocationSearchResult(id: $id, name: $name, address: $address, type: $type, placeId: $placeId, lat: $latitude, lng: $longitude)';
}

/// Types of locations
enum LocationType { city, landmark, business, neighborhood }

/// Extension to get display properties for location types
extension LocationTypeExtension on LocationType {
  String get displayName {
    switch (this) {
      case LocationType.city:
        return 'City';
      case LocationType.landmark:
        return 'Landmark';
      case LocationType.business:
        return 'Business';
      case LocationType.neighborhood:
        return 'Neighborhood';
    }
  }

  String get iconName {
    switch (this) {
      case LocationType.city:
        return 'location_city';
      case LocationType.landmark:
        return 'place';
      case LocationType.business:
        return 'store';
      case LocationType.neighborhood:
        return 'home';
    }
  }
}
