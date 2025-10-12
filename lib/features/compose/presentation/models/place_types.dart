/// Google Place types to emoji mapping and helpers
library;

/// Fallback emoji when no specific type is matched
const String kDefaultPlaceEmoji = '📍';

/// Map of Google Places API types to representative emojis
/// Source: https://developers.google.com/maps/documentation/places/web-service/legacy/supported_types
const Map<String, String> kGooglePlaceTypeToEmoji = {
  // Table 1 common place types
  'accounting': '📊',
  'airport': '✈️',
  'amusement_park': '🎢',
  'aquarium': '🐠',
  'art_gallery': '🖼️',
  'atm': '🏧',
  'bakery': '🥐',
  'bank': '🏦',
  'bar': '🍸',
  'beauty_salon': '💇',
  'bicycle_store': '🚲',
  'book_store': '📚',
  'bowling_alley': '🎳',
  'bus_station': '🚌',
  'cafe': '☕',
  'campground': '🏕️',
  'car_dealer': '🚘',
  'car_rental': '🚗',
  'car_repair': '🔧',
  'car_wash': '🧽',
  'casino': '🎰',
  'cemetery': '🪦',
  'church': '⛪',
  'city_hall': '🏛️',
  'clothing_store': '👗',
  'convenience_store': '🛒',
  'courthouse': '⚖️',
  'dentist': '🦷',
  'department_store': '🛍️',
  'doctor': '🩺',
  'drugstore': '💊',
  'electrician': '🔌',
  'electronics_store': '📺',
  'embassy': '🏛️',
  'fire_station': '🚒',
  'florist': '🌷',
  'funeral_home': '⚰️',
  'furniture_store': '🛋️',
  'gas_station': '⛽',
  'gym': '🏋️',
  'hair_care': '💇',
  'hardware_store': '🛠️',
  'hindu_temple': '🛕',
  'home_goods_store': '🏠',
  'hospital': '🏥',
  'insurance_agency': '🧾',
  'jewelry_store': '💍',
  'laundry': '🧺',
  'lawyer': '⚖️',
  'library': '📚',
  'light_rail_station': '🚈',
  'liquor_store': '🍾',
  'local_government_office': '🏢',
  'locksmith': '🔐',
  'lodging': '🛏️',
  'meal_delivery': '🍽️',
  'meal_takeaway': '🍱',
  'mosque': '🕌',
  'movie_rental': '🎬',
  'movie_theater': '🎥',
  'moving_company': '📦',
  'museum': '🏛️',
  'night_club': '🕺',
  'painter': '🎨',
  'park': '🏞️',
  'parking': '🅿️',
  'pet_store': '🐾',
  'pharmacy': '💊',
  'physiotherapist': '🧘',
  'plumber': '🚿',
  'police': '👮',
  'post_office': '📮',
  'primary_school': '🏫',
  'real_estate_agency': '🏠',
  'restaurant': '🍽️',
  'roofing_contractor': '🏠',
  'rv_park': '🚐',
  'school': '🏫',
  'secondary_school': '🏫',
  'shoe_store': '👟',
  'shopping_mall': '🛍️',
  'spa': '💆',
  'stadium': '🏟️',
  'storage': '📦',
  'store': '🏬',
  'subway_station': '🚇',
  'supermarket': '🛒',
  'synagogue': '🕍',
  'taxi_stand': '🚕',
  'tourist_attraction': '📸',
  'train_station': '🚉',
  'transit_station': '🚉',
  'travel_agency': '✈️',
  'university': '🎓',
  'veterinary_care': '🐶',
  'zoo': '🦁',

  // Common Table 2/other types that often appear
  'locality': '🏙️',
  'neighborhood': '🏘️',
  'natural_feature': '🏔️',
  'route': '🛣️',
  'street_address': '🏠',
  'point_of_interest': '📍',
  'establishment': '🏬',
  'political': '🏛️',
};

/// Returns the first matching emoji for the provided Google Place `types` list.
/// Falls back to a default pin if no mapping exists.
String emojiForTypes(List<String> types) {
  for (final type in types) {
    final emoji = kGooglePlaceTypeToEmoji[type];
    if (emoji != null) {
      return emoji;
    }
  }
  return kDefaultPlaceEmoji;
}

/// Attempts to infer an appropriate emoji from a location name.
/// This is a best-effort approach since we only have the name, not the type.
String emojiForLocationName(String locationName) {
  final name = locationName.toLowerCase();

  // Check for common location name patterns
  if (name.contains('park') || name.contains('garden')) return '🏞️';
  if (name.contains('restaurant') ||
      name.contains('cafe') ||
      name.contains('coffee'))
    return '🍽️';
  if (name.contains('hotel') || name.contains('inn') || name.contains('lodge'))
    return '🛏️';
  if (name.contains('museum') || name.contains('gallery')) return '🏛️';
  if (name.contains('church') ||
      name.contains('temple') ||
      name.contains('mosque'))
    return '⛪';
  if (name.contains('hospital') ||
      name.contains('clinic') ||
      name.contains('medical'))
    return '🏥';
  if (name.contains('school') ||
      name.contains('university') ||
      name.contains('college'))
    return '🏫';
  if (name.contains('airport') || name.contains('station')) return '✈️';
  if (name.contains('mall') ||
      name.contains('shopping') ||
      name.contains('store'))
    return '🛍️';
  if (name.contains('beach') || name.contains('lake') || name.contains('river'))
    return '🏖️';
  if (name.contains('mountain') ||
      name.contains('hill') ||
      name.contains('peak'))
    return '🏔️';
  if (name.contains('zoo') || name.contains('aquarium')) return '🦁';
  if (name.contains('theater') ||
      name.contains('cinema') ||
      name.contains('movie'))
    return '🎥';
  if (name.contains('gym') ||
      name.contains('fitness') ||
      name.contains('sport'))
    return '🏋️';
  if (name.contains('library')) return '📚';
  if (name.contains('bank')) return '🏦';
  if (name.contains('gas') || name.contains('fuel')) return '⛽';
  if (name.contains('pharmacy') || name.contains('drug')) return '💊';
  if (name.contains('bar') || name.contains('pub') || name.contains('club'))
    return '🍸';
  if (name.contains('bakery') || name.contains('bread')) return '🥐';
  if (name.contains('pizza')) return '🍕';
  if (name.contains('burger')) return '🍔';
  if (name.contains('sushi')) return '🍣';
  if (name.contains('ice cream') || name.contains('dessert')) return '🍦';
  if (name.contains('market') || name.contains('grocery')) return '🛒';
  if (name.contains('office') || name.contains('building')) return '🏢';
  if (name.contains('home') || name.contains('house')) return '🏠';
  if (name.contains('city') || name.contains('downtown')) return '🏙️';
  if (name.contains('street') ||
      name.contains('avenue') ||
      name.contains('road'))
    return '🛣️';

  // Default fallback
  return kDefaultPlaceEmoji;
}

/// Comprehensive emoji mapping that combines Google Places API types with intelligent name-based fallbacks.
/// This is the main function to use for getting emojis for locations.
String emojiForLocation({List<String>? types, String? locationName}) {
  // First, try to use Google Places API types if available
  if (types != null && types.isNotEmpty) {
    final emoji = emojiForTypes(types);
    if (emoji != kDefaultPlaceEmoji) {
      return emoji;
    }
  }

  // If no types or no match found, try to infer from location name
  if (locationName != null && locationName.isNotEmpty) {
    return emojiForLocationName(locationName);
  }

  // Final fallback
  return kDefaultPlaceEmoji;
}
