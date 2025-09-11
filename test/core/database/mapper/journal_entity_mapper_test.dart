import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_app/core/database/mapper/journal_entity_mapper.dart';
import 'package:my_flutter_app/shared/domain/entities/journal.dart';

void main() {
  group('JournalEntityMapper', () {
    group('mapToJournal', () {
      test('should map database row to Journal entity correctly', () {
        // Arrange
        final dbRow = {
          'id': 1,
          'title': 'Test Journal',
          'content': 'Test content',
          'created_at': '2024-01-01T10:00:00.000Z',
          'updated_at': '2024-01-01T11:00:00.000Z',
          'is_favorite': 1,
          'tags': 'personal,reflection',
          'image_urls': 'image1.jpg,image2.jpg',
        };

        // Act
        final result = JournalEntityMapper.mapToJournal(dbRow);

        // Assert
        expect(result.id, '1');
        expect(result.title, 'Test Journal');
        expect(result.content, 'Test content');
        expect(result.createdAt, DateTime.parse('2024-01-01T10:00:00.000Z'));
        expect(result.updatedAt, DateTime.parse('2024-01-01T11:00:00.000Z'));
        expect(result.isFavorite, true);
        expect(result.tags, ['personal', 'reflection']);
        expect(result.imageUrls, ['image1.jpg', 'image2.jpg']);
      });

      test('should handle null tags and imageUrls', () {
        // Arrange
        final dbRow = {
          'id': 2,
          'title': 'Test Journal 2',
          'content': 'Test content 2',
          'created_at': '2024-01-01T10:00:00.000Z',
          'updated_at': '2024-01-01T11:00:00.000Z',
          'is_favorite': 0,
          'tags': null,
          'image_urls': null,
        };

        // Act
        final result = JournalEntityMapper.mapToJournal(dbRow);

        // Assert
        expect(result.tags, isEmpty);
        expect(result.imageUrls, isEmpty);
        expect(result.isFavorite, false);
      });

      test('should handle empty tags and imageUrls strings', () {
        // Arrange
        final dbRow = {
          'id': 3,
          'title': 'Test Journal 3',
          'content': 'Test content 3',
          'created_at': '2024-01-01T10:00:00.000Z',
          'updated_at': '2024-01-01T11:00:00.000Z',
          'is_favorite': 0,
          'tags': '',
          'image_urls': '',
        };

        // Act
        final result = JournalEntityMapper.mapToJournal(dbRow);

        // Assert
        expect(result.tags, isEmpty);
        expect(result.imageUrls, isEmpty);
      });

      test('should handle tags and imageUrls with empty items', () {
        // Arrange
        final dbRow = {
          'id': 4,
          'title': 'Test Journal 4',
          'content': 'Test content 4',
          'created_at': '2024-01-01T10:00:00.000Z',
          'updated_at': '2024-01-01T11:00:00.000Z',
          'is_favorite': 0,
          'tags': 'tag1,,tag2,',
          'image_urls': ',image1.jpg,,image2.jpg,',
        };

        // Act
        final result = JournalEntityMapper.mapToJournal(dbRow);

        // Assert
        expect(result.tags, ['tag1', 'tag2']);
        expect(result.imageUrls, ['image1.jpg', 'image2.jpg']);
      });

      test('should handle tags and imageUrls with whitespace', () {
        // Arrange
        final dbRow = {
          'id': 5,
          'title': 'Test Journal 5',
          'content': 'Test content 5',
          'created_at': '2024-01-01T10:00:00.000Z',
          'updated_at': '2024-01-01T11:00:00.000Z',
          'is_favorite': 0,
          'tags': ' tag1 , tag2 ',
          'image_urls': ' image1.jpg , image2.jpg ',
        };

        // Act
        final result = JournalEntityMapper.mapToJournal(dbRow);

        // Assert
        expect(result.tags, ['tag1', 'tag2']);
        expect(result.imageUrls, ['image1.jpg', 'image2.jpg']);
      });
    });

    group('mapToJournalList', () {
      test('should map list of database rows to Journal entities', () {
        // Arrange
        final dbRows = [
          {
            'id': 1,
            'title': 'Journal 1',
            'content': 'Content 1',
            'created_at': '2024-01-01T10:00:00.000Z',
            'updated_at': '2024-01-01T11:00:00.000Z',
            'is_favorite': 1,
            'tags': 'tag1',
            'image_urls': 'image1.jpg',
          },
          {
            'id': 2,
            'title': 'Journal 2',
            'content': 'Content 2',
            'created_at': '2024-01-01T12:00:00.000Z',
            'updated_at': '2024-01-01T13:00:00.000Z',
            'is_favorite': 0,
            'tags': 'tag2',
            'image_urls': 'image2.jpg',
          },
        ];

        // Act
        final result = JournalEntityMapper.mapToJournalList(dbRows);

        // Assert
        expect(result, hasLength(2));
        expect(result[0].title, 'Journal 1');
        expect(result[1].title, 'Journal 2');
        expect(result[0].isFavorite, true);
        expect(result[1].isFavorite, false);
      });

      test('should return empty list for empty input', () {
        // Arrange
        final dbRows = <Map<String, dynamic>>[];

        // Act
        final result = JournalEntityMapper.mapToJournalList(dbRows);

        // Assert
        expect(result, isEmpty);
      });
    });

    group('journalToMap', () {
      test(
        'should convert Journal entity to database row map for insertion',
        () {
          // Arrange
          final journal = Journal(
            id: '0',
            title: 'Test Journal',
            content: 'Test content',
            createdAt: DateTime.parse('2024-01-01T10:00:00.000Z'),
            updatedAt: DateTime.parse('2024-01-01T11:00:00.000Z'),
            isFavorite: true,
            tags: ['personal', 'reflection'],
            imageUrls: ['image1.jpg', 'image2.jpg'],
          );

          // Act
          final result = JournalEntityMapper.journalToMap(journal);

          // Assert
          expect(result['title'], 'Test Journal');
          expect(result['content'], 'Test content');
          expect(result['created_at'], '2024-01-01T10:00:00.000Z');
          expect(result['updated_at'], '2024-01-01T11:00:00.000Z');
          expect(result['is_favorite'], 1);
          expect(result['tags'], 'personal,reflection');
          expect(result['image_urls'], 'image1.jpg,image2.jpg');
          expect(
            result.containsKey('id'),
            false,
          ); // Should not include id for insertion
        },
      );

      test('should handle empty tags and imageUrls', () {
        // Arrange
        final journal = Journal(
          id: '0',
          title: 'Test Journal',
          content: 'Test content',
          createdAt: DateTime.parse('2024-01-01T10:00:00.000Z'),
          updatedAt: DateTime.parse('2024-01-01T11:00:00.000Z'),
          isFavorite: false,
          tags: [],
          imageUrls: [],
        );

        // Act
        final result = JournalEntityMapper.journalToMap(journal);

        // Assert
        expect(result['tags'], '');
        expect(result['image_urls'], '');
        expect(result['is_favorite'], 0);
      });
    });

    group('journalToUpdateMap', () {
      test('should convert Journal entity to database row map for updates', () {
        // Arrange
        final journal = Journal(
          id: '1',
          title: 'Updated Journal',
          content: 'Updated content',
          createdAt: DateTime.parse('2024-01-01T10:00:00.000Z'),
          updatedAt: DateTime.parse('2024-01-01T12:00:00.000Z'),
          isFavorite: true,
          tags: ['updated', 'tag'],
          imageUrls: ['new-image.jpg'],
        );

        // Act
        final result = JournalEntityMapper.journalToUpdateMap(journal);

        // Assert
        expect(result['title'], 'Updated Journal');
        expect(result['content'], 'Updated content');
        expect(result['updated_at'], '2024-01-01T12:00:00.000Z');
        expect(result['is_favorite'], 1);
        expect(result['tags'], 'updated,tag');
        expect(result['image_urls'], 'new-image.jpg');
        expect(
          result.containsKey('id'),
          false,
        ); // Should not include id for updates
        expect(
          result.containsKey('created_at'),
          false,
        ); // Should not include created_at for updates
      });
    });

    group('_parseCommaSeparatedString', () {
      test('should parse comma-separated string correctly', () {
        // This is a private method, but we can test it indirectly through mapToJournal
        final dbRow = {
          'id': 1,
          'title': 'Test',
          'content': 'Test',
          'created_at': '2024-01-01T10:00:00.000Z',
          'updated_at': '2024-01-01T11:00:00.000Z',
          'is_favorite': 0,
          'tags': 'tag1,tag2,tag3',
          'image_urls': 'img1.jpg,img2.jpg',
        };

        final result = JournalEntityMapper.mapToJournal(dbRow);

        expect(result.tags, ['tag1', 'tag2', 'tag3']);
        expect(result.imageUrls, ['img1.jpg', 'img2.jpg']);
      });

      test('should handle single item', () {
        final dbRow = {
          'id': 1,
          'title': 'Test',
          'content': 'Test',
          'created_at': '2024-01-01T10:00:00.000Z',
          'updated_at': '2024-01-01T11:00:00.000Z',
          'is_favorite': 0,
          'tags': 'single-tag',
          'image_urls': 'single-image.jpg',
        };

        final result = JournalEntityMapper.mapToJournal(dbRow);

        expect(result.tags, ['single-tag']);
        expect(result.imageUrls, ['single-image.jpg']);
      });
    });
  });
}
