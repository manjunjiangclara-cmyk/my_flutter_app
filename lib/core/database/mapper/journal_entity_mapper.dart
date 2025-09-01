import '../../../../features/journal/domain/entities/journal.dart';

class JournalEntityMapper {
  /// Maps a database row map to a Journal entity
  static Journal mapToJournal(Map<String, dynamic> map) {
    return Journal(
      id: map['id'].toString(),
      title: map['title'],
      content: map['content'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      isFavorite: map['is_favorite'] == 1,
      tags: _parseCommaSeparatedString(map['tags']),
      imageUrls: _parseCommaSeparatedString(map['image_urls']),
    );
  }

  /// Maps a list of database row maps to a list of Journal entities
  static List<Journal> mapToJournalList(List<Map<String, dynamic>> maps) {
    return maps.map((map) => mapToJournal(map)).toList();
  }

  /// Parses a comma-separated string into a list, filtering out empty values
  static List<String> _parseCommaSeparatedString(String? value) {
    if (value == null || value.isEmpty) return [];
    return value
        .split(',')
        .where((item) => item.trim().isNotEmpty)
        .map((item) => item.trim())
        .toList();
  }

  /// Converts a Journal entity to a database row map for insertion
  static Map<String, dynamic> journalToMap(Journal journal) {
    return {
      'title': journal.title,
      'content': journal.content,
      'created_at': journal.createdAt.toIso8601String(),
      'updated_at': journal.updatedAt.toIso8601String(),
      'is_favorite': journal.isFavorite ? 1 : 0,
      'tags': journal.tags.join(','),
      'image_urls': journal.imageUrls.join(','),
    };
  }

  /// Converts a Journal entity to a database row map for updates
  static Map<String, dynamic> journalToUpdateMap(Journal journal) {
    return {
      'title': journal.title,
      'content': journal.content,
      'updated_at': journal.updatedAt.toIso8601String(),
      'is_favorite': journal.isFavorite ? 1 : 0,
      'tags': journal.tags.join(','),
      'image_urls': journal.imageUrls.join(','),
    };
  }
}
