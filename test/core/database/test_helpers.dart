import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_app/shared/domain/entities/journal.dart';

/// Test helper class for database tests
class DatabaseTestHelpers {
  /// Creates a sample journal for testing
  static Journal createSampleJournal({
    String id = '1',
    String content = 'Test content',
    DateTime? createdAt,
    DateTime? updatedAt,
    bool isFavorite = false,
    List<String> tags = const ['test', 'sample'],
    List<String> imagePaths = const ['image1.jpg'],
    String? location,
  }) {
    return Journal(
      id: id,
      content: content,
      createdAt: createdAt ?? DateTime.parse('2024-01-01T10:00:00.000Z'),
      updatedAt: updatedAt ?? DateTime.parse('2024-01-01T11:00:00.000Z'),
      isFavorite: isFavorite,
      tags: tags,
      imagePaths: imagePaths,
      location: location,
    );
  }

  /// Creates a list of sample journals for testing
  static List<Journal> createSampleJournals({int count = 3}) {
    return List.generate(count, (index) {
      return createSampleJournal(
        id: (index + 1).toString(),
        content: 'Test content ${index + 1}',
        createdAt: DateTime.parse('2024-01-0${index + 1}T10:00:00.000Z'),
        updatedAt: DateTime.parse('2024-01-0${index + 1}T11:00:00.000Z'),
        isFavorite: index % 2 == 0, // Alternate favorites
        tags: ['tag${index + 1}', 'sample'],
        imagePaths: ['image${index + 1}.jpg'],
        location: 'Location ${index + 1}',
      );
    });
  }

  /// Creates a sample database row map for testing
  static Map<String, dynamic> createSampleDbRow({
    int id = 1,
    String content = 'Test content',
    String createdAt = '2024-01-01T10:00:00.000Z',
    String updatedAt = '2024-01-01T11:00:00.000Z',
    int isFavorite = 0,
    String tags = 'test,sample',
    String imagePaths = 'image1.jpg',
    String? location,
  }) {
    return {
      'id': id,
      'content': content,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'is_favorite': isFavorite,
      'tags': tags,
      'image_paths': imagePaths,
      'location': location,
    };
  }

  /// Creates a list of sample database row maps for testing
  static List<Map<String, dynamic>> createSampleDbRows({int count = 3}) {
    return List.generate(count, (index) {
      return createSampleDbRow(
        id: index + 1,
        content: 'Test content ${index + 1}',
        createdAt: '2024-01-0${index + 1}T10:00:00.000Z',
        updatedAt: '2024-01-0${index + 1}T11:00:00.000Z',
        isFavorite: index % 2,
        tags: 'tag${index + 1},sample',
        imagePaths: 'image${index + 1}.jpg',
        location: 'Location ${index + 1}',
      );
    });
  }

  /// Asserts that two journals are equal (ignoring ID for new entries)
  static void assertJournalsEqual(
    Journal expected,
    Journal actual, {
    bool ignoreId = false,
  }) {
    if (!ignoreId) {
      expect(actual.id, expected.id);
    }
    expect(actual.content, expected.content);
    expect(actual.createdAt, expected.createdAt);
    expect(actual.updatedAt, expected.updatedAt);
    expect(actual.isFavorite, expected.isFavorite);
    expect(actual.tags, expected.tags);
    expect(actual.imagePaths, expected.imagePaths);
    expect(actual.location, expected.location);
  }

  /// Asserts that a journal matches a database row
  static void assertJournalMatchesDbRow(
    Journal journal,
    Map<String, dynamic> dbRow,
  ) {
    expect(journal.id, dbRow['id'].toString());
    expect(journal.content, dbRow['content']);
    expect(journal.createdAt, DateTime.parse(dbRow['created_at']));
    expect(journal.updatedAt, DateTime.parse(dbRow['updated_at']));
    expect(journal.isFavorite, dbRow['is_favorite'] == 1);
    expect(
      journal.tags,
      dbRow['tags']?.split(',').where((tag) => tag.isNotEmpty).toList() ?? [],
    );
    expect(
      journal.imagePaths,
      dbRow['image_paths']
              ?.split(',')
              .where((path) => path.isNotEmpty)
              .toList() ??
          [],
    );
  }
}
