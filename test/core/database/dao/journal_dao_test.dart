import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:my_flutter_app/core/database/dao/journal_dao.dart';
import 'package:my_flutter_app/core/database/database_helper.dart';
import 'package:my_flutter_app/shared/domain/entities/journal.dart';
import 'package:sqflite/sqflite.dart';

import 'journal_dao_test.mocks.dart';

@GenerateMocks([DatabaseHelper, Database, Batch])
void main() {
  group('JournalDao', () {
    late JournalDao journalDao;
    late MockDatabaseHelper mockDatabaseHelper;
    late MockDatabase mockDatabase;
    late MockBatch mockBatch;

    setUp(() {
      mockDatabaseHelper = MockDatabaseHelper();
      mockDatabase = MockDatabase();
      mockBatch = MockBatch();
      journalDao = JournalDao(mockDatabaseHelper);
    });

    group('insert', () {
      test('should insert journal and return row id', () async {
        // Arrange
        final journal = Journal(
          id: '0',
          content: 'Test content',
          createdAt: DateTime.parse('2024-01-01T10:00:00.000Z'),
          updatedAt: DateTime.parse('2024-01-01T11:00:00.000Z'),
          isFavorite: true,
          tags: ['personal', 'reflection'],
          imageUrls: ['image1.jpg'],
          location: 'Test Location',
        );

        when(mockDatabaseHelper.database).thenAnswer((_) async => mockDatabase);
        when(mockDatabase.insert(any, any)).thenAnswer((_) async => 1);

        // Act
        final result = await journalDao.insert(journal);

        // Assert
        expect(result, 1);
        verify(mockDatabase.insert(JournalDao.tableName, any)).called(1);
      });
    });

    group('update', () {
      test('should update journal and return affected rows count', () async {
        // Arrange
        final journal = Journal(
          id: '1',
          content: 'Updated content',
          createdAt: DateTime.parse('2024-01-01T10:00:00.000Z'),
          updatedAt: DateTime.parse('2024-01-01T12:00:00.000Z'),
          isFavorite: false,
          tags: ['updated'],
          imageUrls: [],
          location: 'Updated Location',
        );

        when(mockDatabaseHelper.database).thenAnswer((_) async => mockDatabase);
        when(
          mockDatabase.update(
            any,
            any,
            where: anyNamed('where'),
            whereArgs: anyNamed('whereArgs'),
          ),
        ).thenAnswer((_) async => 1);

        // Act
        final result = await journalDao.update(journal);

        // Assert
        expect(result, 1);
        verify(
          mockDatabase.update(
            JournalDao.tableName,
            any,
            where: 'id = ?',
            whereArgs: [1],
          ),
        ).called(1);
      });
    });

    group('deleteById', () {
      test(
        'should delete journal by id and return affected rows count',
        () async {
          // Arrange
          const journalId = '1';

          when(
            mockDatabaseHelper.database,
          ).thenAnswer((_) async => mockDatabase);
          when(
            mockDatabase.delete(
              any,
              where: anyNamed('where'),
              whereArgs: anyNamed('whereArgs'),
            ),
          ).thenAnswer((_) async => 1);

          // Act
          final result = await journalDao.deleteById(journalId);

          // Assert
          expect(result, 1);
          verify(
            mockDatabase.delete(
              JournalDao.tableName,
              where: 'id = ?',
              whereArgs: [1],
            ),
          ).called(1);
        },
      );
    });

    group('findById', () {
      test('should return journal when found', () async {
        // Arrange
        const journalId = '1';
        final dbRow = {
          'id': 1,
          'content': 'Test content',
          'created_at': '2024-01-01T10:00:00.000Z',
          'updated_at': '2024-01-01T11:00:00.000Z',
          'is_favorite': 1,
          'tags': 'personal,reflection',
          'image_urls': 'image1.jpg',
          'location': 'Test Location',
        };

        when(mockDatabaseHelper.database).thenAnswer((_) async => mockDatabase);
        when(
          mockDatabase.query(
            any,
            where: anyNamed('where'),
            whereArgs: anyNamed('whereArgs'),
            limit: anyNamed('limit'),
          ),
        ).thenAnswer((_) async => [dbRow]);

        // Act
        final result = await journalDao.findById(journalId);

        // Assert
        expect(result, isNotNull);
        expect(result!.content, 'Test content');
        expect(result.isFavorite, true);
        verify(
          mockDatabase.query(
            JournalDao.tableName,
            where: 'id = ?',
            whereArgs: [1],
            limit: 1,
          ),
        ).called(1);
      });

      test('should return null when journal not found', () async {
        // Arrange
        const journalId = '999';

        when(mockDatabaseHelper.database).thenAnswer((_) async => mockDatabase);
        when(
          mockDatabase.query(
            any,
            where: anyNamed('where'),
            whereArgs: anyNamed('whereArgs'),
            limit: anyNamed('limit'),
          ),
        ).thenAnswer((_) async => <Map<String, dynamic>>[]);

        // Act
        final result = await journalDao.findById(journalId);

        // Assert
        expect(result, isNull);
      });
    });

    group('findAll', () {
      test('should return all journals ordered by creation date', () async {
        // Arrange
        final dbRows = [
          {
            'id': 1,
            'content': 'Content 1',
            'created_at': '2024-01-01T10:00:00.000Z',
            'updated_at': '2024-01-01T11:00:00.000Z',
            'is_favorite': 1,
            'tags': 'tag1',
            'image_urls': 'image1.jpg',
            'location': 'Location 1',
          },
          {
            'id': 2,
            'content': 'Content 2',
            'created_at': '2024-01-01T12:00:00.000Z',
            'updated_at': '2024-01-01T13:00:00.000Z',
            'is_favorite': 0,
            'tags': 'tag2',
            'image_urls': 'image2.jpg',
            'location': 'Location 2',
          },
        ];

        when(mockDatabaseHelper.database).thenAnswer((_) async => mockDatabase);
        when(
          mockDatabase.query(
            any,
            orderBy: anyNamed('orderBy'),
            limit: anyNamed('limit'),
          ),
        ).thenAnswer((_) async => dbRows);

        // Act
        final result = await journalDao.findAll();

        // Assert
        expect(result, hasLength(2));
        expect(result[0].content, 'Content 1');
        expect(result[1].content, 'Content 2');
        verify(
          mockDatabase.query(
            JournalDao.tableName,
            orderBy: 'created_at DESC',
            limit: 50, // Default limit from constants
          ),
        ).called(1);
      });
    });

    group('findFavorites', () {
      test('should return only favorite journals', () async {
        // Arrange
        final dbRows = [
          {
            'id': 1,
            'content': 'Favorite content',
            'created_at': '2024-01-01T10:00:00.000Z',
            'updated_at': '2024-01-01T11:00:00.000Z',
            'is_favorite': 1,
            'tags': 'favorite',
            'image_urls': 'favorite.jpg',
            'location': 'Favorite Location',
          },
        ];

        when(mockDatabaseHelper.database).thenAnswer((_) async => mockDatabase);
        when(
          mockDatabase.query(
            any,
            where: anyNamed('where'),
            whereArgs: anyNamed('whereArgs'),
            orderBy: anyNamed('orderBy'),
            limit: anyNamed('limit'),
          ),
        ).thenAnswer((_) async => dbRows);

        // Act
        final result = await journalDao.findFavorites();

        // Assert
        expect(result, hasLength(1));
        expect(result[0].content, 'Favorite content');
        expect(result[0].isFavorite, true);
        verify(
          mockDatabase.query(
            JournalDao.tableName,
            where: 'is_favorite = ?',
            whereArgs: [1],
            orderBy: 'created_at DESC',
            limit: 50,
          ),
        ).called(1);
      });
    });

    group('search', () {
      test('should search journals by content', () async {
        // Arrange
        const query = 'test';
        final dbRows = [
          {
            'id': 1,
            'content': 'Test content',
            'created_at': '2024-01-01T10:00:00.000Z',
            'updated_at': '2024-01-01T11:00:00.000Z',
            'is_favorite': 0,
            'tags': 'tag1',
            'image_urls': '',
            'location': 'Test Location',
          },
        ];

        when(mockDatabaseHelper.database).thenAnswer((_) async => mockDatabase);
        when(
          mockDatabase.query(
            any,
            where: anyNamed('where'),
            whereArgs: anyNamed('whereArgs'),
            orderBy: anyNamed('orderBy'),
            limit: anyNamed('limit'),
          ),
        ).thenAnswer((_) async => dbRows);

        // Act
        final result = await journalDao.search(query);

        // Assert
        expect(result, hasLength(1));
        expect(result[0].content, 'Test content');
        verify(
          mockDatabase.query(
            JournalDao.tableName,
            where: 'content LIKE ?',
            whereArgs: ['%test%'],
            orderBy: 'created_at DESC',
            limit: 50,
          ),
        ).called(1);
      });
    });

    group('findByTag', () {
      test('should return journals with specific tag', () async {
        // Arrange
        const tag = 'personal';
        final dbRows = [
          {
            'id': 1,
            'content': 'Personal content',
            'created_at': '2024-01-01T10:00:00.000Z',
            'updated_at': '2024-01-01T11:00:00.000Z',
            'is_favorite': 0,
            'tags': 'personal,reflection',
            'image_urls': '',
            'location': 'Personal Location',
          },
        ];

        when(mockDatabaseHelper.database).thenAnswer((_) async => mockDatabase);
        when(
          mockDatabase.query(
            any,
            where: anyNamed('where'),
            whereArgs: anyNamed('whereArgs'),
            orderBy: anyNamed('orderBy'),
            limit: anyNamed('limit'),
          ),
        ).thenAnswer((_) async => dbRows);

        // Act
        final result = await journalDao.findByTag(tag);

        // Assert
        expect(result, hasLength(1));
        expect(result[0].content, 'Personal content');
        verify(
          mockDatabase.query(
            JournalDao.tableName,
            where: 'tags LIKE ?',
            whereArgs: ['%personal%'],
            orderBy: 'created_at DESC',
            limit: 50,
          ),
        ).called(1);
      });
    });

    group('findByDateRange', () {
      test('should return journals within date range', () async {
        // Arrange
        final start = DateTime.parse('2024-01-01T00:00:00.000Z');
        final end = DateTime.parse('2024-01-31T23:59:59.000Z');
        final dbRows = [
          {
            'id': 1,
            'content': 'January content',
            'created_at': '2024-01-15T10:00:00.000Z',
            'updated_at': '2024-01-15T11:00:00.000Z',
            'is_favorite': 0,
            'tags': 'january',
            'image_urls': '',
            'location': 'January Location',
          },
        ];

        when(mockDatabaseHelper.database).thenAnswer((_) async => mockDatabase);
        when(
          mockDatabase.query(
            any,
            where: anyNamed('where'),
            whereArgs: anyNamed('whereArgs'),
            orderBy: anyNamed('orderBy'),
            limit: anyNamed('limit'),
          ),
        ).thenAnswer((_) async => dbRows);

        // Act
        final result = await journalDao.findByDateRange(start, end);

        // Assert
        expect(result, hasLength(1));
        expect(result[0].content, 'January content');
        verify(
          mockDatabase.query(
            JournalDao.tableName,
            where: 'created_at BETWEEN ? AND ?',
            whereArgs: [start.toIso8601String(), end.toIso8601String()],
            orderBy: 'created_at DESC',
            limit: 50,
          ),
        ).called(1);
      });
    });

    group('getCount', () {
      test('should return total journal count', () async {
        // Arrange
        when(mockDatabaseHelper.database).thenAnswer((_) async => mockDatabase);
        when(mockDatabase.rawQuery(any)).thenAnswer(
          (_) async => [
            {'COUNT(*)': 5},
          ],
        );

        // Act
        final result = await journalDao.getCount();

        // Assert
        expect(result, 5);
        verify(
          mockDatabase.rawQuery('SELECT COUNT(*) FROM ${JournalDao.tableName}'),
        ).called(1);
      });
    });

    group('insertBatch', () {
      test('should insert multiple journals in batch', () async {
        // Arrange
        final journals = [
          Journal(
            id: '0',
            content: 'Content 1',
            createdAt: DateTime.parse('2024-01-01T10:00:00.000Z'),
            updatedAt: DateTime.parse('2024-01-01T11:00:00.000Z'),
            isFavorite: false,
            tags: [],
            imageUrls: [],
            location: 'Location 1',
          ),
          Journal(
            id: '0',
            content: 'Content 2',
            createdAt: DateTime.parse('2024-01-01T12:00:00.000Z'),
            updatedAt: DateTime.parse('2024-01-01T13:00:00.000Z'),
            isFavorite: true,
            tags: ['favorite'],
            imageUrls: ['image.jpg'],
            location: 'Location 2',
          ),
        ];

        when(mockDatabaseHelper.database).thenAnswer((_) async => mockDatabase);
        when(mockDatabase.batch()).thenReturn(mockBatch);
        when(mockBatch.insert(any, any)).thenReturn(null);
        when(
          mockBatch.commit(noResult: anyNamed('noResult')),
        ).thenAnswer((_) async => <Object?>[]);

        // Act
        await journalDao.insertBatch(journals);

        // Assert
        verify(mockDatabase.batch()).called(1);
        verify(mockBatch.insert(JournalDao.tableName, any)).called(2);
        verify(mockBatch.commit(noResult: true)).called(1);
      });
    });

    group('toggleFavorite', () {
      test('should toggle favorite status', () async {
        // Arrange
        const journalId = '1';
        const isFavorite = true;

        when(mockDatabaseHelper.database).thenAnswer((_) async => mockDatabase);
        when(
          mockDatabase.update(
            any,
            any,
            where: anyNamed('where'),
            whereArgs: anyNamed('whereArgs'),
          ),
        ).thenAnswer((_) async => 1);

        // Act
        final result = await journalDao.toggleFavorite(journalId, isFavorite);

        // Assert
        expect(result, 1);
        verify(
          mockDatabase.update(
            JournalDao.tableName,
            {'is_favorite': 1},
            where: 'id = ?',
            whereArgs: [1],
          ),
        ).called(1);
      });
    });

    group('Constants', () {
      test('should have correct table name', () {
        expect(JournalDao.tableName, 'journals');
      });

      test('should have correct column names', () {
        expect(JournalDao.columnId, 'id');
        expect(JournalDao.columnContent, 'content');
        expect(JournalDao.columnCreatedAt, 'created_at');
        expect(JournalDao.columnUpdatedAt, 'updated_at');
        expect(JournalDao.columnIsFavorite, 'is_favorite');
        expect(JournalDao.columnTags, 'tags');
        expect(JournalDao.columnImageUrls, 'image_urls');
        expect(JournalDao.columnLocation, 'location');
      });

      test('should have valid create table SQL', () {
        expect(JournalDao.createTableSQL, contains('CREATE TABLE journals'));
        expect(
          JournalDao.createTableSQL,
          contains('id INTEGER PRIMARY KEY AUTOINCREMENT'),
        );
        expect(JournalDao.createTableSQL, contains('content TEXT NOT NULL'));
        expect(JournalDao.createTableSQL, contains('location TEXT'));
      });
    });
  });
}
