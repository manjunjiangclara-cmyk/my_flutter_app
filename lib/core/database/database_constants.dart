class DatabaseConstants {
  // Database Configuration
  static const String databaseName = 'journal_app.db';
  static const int databaseVersion = 1;

  // Table Names
  static const String journalsTable = 'journals';
  static const String tagsTable = 'tags';
  static const String journalTagsTable = 'journal_tags';

  // Journal Table Columns
  static const String journalId = 'id';
  static const String journalTitle = 'title';
  static const String journalContent = 'content';
  static const String journalCreatedAt = 'created_at';
  static const String journalUpdatedAt = 'updated_at';
  static const String journalIsFavorite = 'is_favorite';
  static const String journalTags = 'tags';
  static const String journalImageUrls = 'image_urls';

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

  // Query Limits
  static const int defaultQueryLimit = 50;
  static const int maxQueryLimit = 1000;
}
