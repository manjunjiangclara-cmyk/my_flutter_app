import '../../../shared/domain/entities/journal.dart';
import '../../utils/string_list_parser.dart';

class JournalEntityMapper {
  /// Maps a database row map to a Journal entity
  static Journal mapToJournal(Map<String, dynamic> map) {
    final imagePaths = parseCommaSeparatedString(map['image_paths']);

    // Debug: Print image paths from database
    print('📊 Journal ${map['id']} - Raw image_paths: "${map['image_paths']}"');
    print('📊 Journal ${map['id']} - Parsed imagePaths: $imagePaths');

    return Journal(
      id: map['id'].toString(),
      content: map['content'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      isFavorite: map['is_favorite'] == 1,
      tags: parseCommaSeparatedString(map['tags']),
      imagePaths: imagePaths,
      location: map['location'],
    );
  }

  /// Maps a list of database row maps to a list of Journal entities
  static List<Journal> mapToJournalList(List<Map<String, dynamic>> maps) {
    return maps.map((map) => mapToJournal(map)).toList();
  }

  // moved parsing util to utils/string_list_parser.dart

  /// Converts a Journal entity to a database row map for insertion
  static Map<String, dynamic> journalToMap(Journal journal) {
    return {
      'content': journal.content,
      'created_at': journal.createdAt.toIso8601String(),
      'updated_at': journal.updatedAt.toIso8601String(),
      'is_favorite': journal.isFavorite ? 1 : 0,
      'tags': journal.tags.join(','),
      'image_paths': journal.imagePaths.join(','),
      'location': journal.location,
    };
  }

  /// Converts a Journal entity to a database row map for updates
  static Map<String, dynamic> journalToUpdateMap(Journal journal) {
    return {
      'content': journal.content,
      'updated_at': journal.updatedAt.toIso8601String(),
      'is_favorite': journal.isFavorite ? 1 : 0,
      'tags': journal.tags.join(','),
      'image_paths': journal.imagePaths.join(','),
      'location': journal.location,
    };
  }

  /// Builds a map to update only the favorite flag
  static Map<String, dynamic> favoriteUpdateMap(bool isFavorite) {
    return {'is_favorite': isFavorite ? 1 : 0};
  }
}
