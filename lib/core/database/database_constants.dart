class DatabaseConstants {
  // Database Configuration
  static const String databaseName = 'journal_app.db';
  static const int databaseVersion = 2;

  // Table Names
  static const String journalsTable = 'journals';
  static const String tagsTable = 'tags';
  static const String journalTagsTable = 'journal_tags';

  // Journal Table Columns
  static const String journalId = 'id';
  static const String journalContent = 'content';
  static const String journalCreatedAt = 'created_at';
  static const String journalUpdatedAt = 'updated_at';
  static const String journalIsFavorite = 'is_favorite';
  static const String journalTags = 'tags';
  static const String journalImageUrls = 'image_urls';
  static const String journalLocation = 'location';
  static const String journalLocationName = 'location_name';
  static const String journalLocationAddress = 'location_address';
  static const String journalLocationPlaceId = 'location_place_id';
  static const String journalLocationLatitude = 'location_latitude';
  static const String journalLocationLongitude = 'location_longitude';

  // Tags Table Columns
  static const String tagId = 'id';
  static const String tagName = 'name';
  static const String tagColor = 'color';
  static const String tagCreatedAt = 'created_at';

  // Journal Tags Junction Table Columns
  static const String journalTagJournalId = 'journal_id';
  static const String journalTagTagId = 'tag_id';

  // Default Values
  static const int defaultIsFavorite = 0;
  static const String defaultTags = '';
  static const String defaultImageUrls = '';
  static const String defaultLocation = '';
  static const String defaultLocationName = '';
  static const String defaultLocationAddress = '';
  static const String defaultLocationPlaceId = '';
  static const double defaultLocationLatitude = 0.0;
  static const double defaultLocationLongitude = 0.0;
  static const String defaultLocationTypes = '';

  // Query Limits
  static const int defaultQueryLimit = 50;
  static const int maxQueryLimit = 1000;
}
