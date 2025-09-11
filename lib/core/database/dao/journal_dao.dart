import 'package:sqflite/sqflite.dart';

import '../../../shared/domain/entities/journal.dart';
import '../database_constants.dart';
import '../database_helper.dart';
import '../mapper/journal_entity_mapper.dart';

class JournalDao {
  final DatabaseHelper _databaseHelper;

  JournalDao([DatabaseHelper? databaseHelper])
    : _databaseHelper = databaseHelper ?? DatabaseHelper.instance;

  // Table name
  static const String tableName = DatabaseConstants.journalsTable;

  // Column names
  static const String columnId = DatabaseConstants.journalId;
  static const String columnTitle = DatabaseConstants.journalTitle;
  static const String columnContent = DatabaseConstants.journalContent;
  static const String columnCreatedAt = DatabaseConstants.journalCreatedAt;
  static const String columnUpdatedAt = DatabaseConstants.journalUpdatedAt;
  static const String columnIsFavorite = DatabaseConstants.journalIsFavorite;
  static const String columnTags = DatabaseConstants.journalTags;
  static const String columnImageUrls = DatabaseConstants.journalImageUrls;

  // Create table SQL
  static const String createTableSQL =
      '''
      CREATE TABLE $tableName(
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnTitle TEXT NOT NULL,
        $columnContent TEXT NOT NULL,
        $columnCreatedAt TEXT NOT NULL,
        $columnUpdatedAt TEXT NOT NULL,
        $columnIsFavorite INTEGER DEFAULT ${DatabaseConstants.defaultIsFavorite},
        $columnTags TEXT,
        $columnImageUrls TEXT
      )
    ''';

  // Common query helper to reduce duplication
  Future<List<Journal>> _queryJournals({
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
  }) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy ?? '$columnCreatedAt DESC',
      limit: limit ?? DatabaseConstants.defaultQueryLimit,
    );

    return JournalEntityMapper.mapToJournalList(maps);
  }

  // Common single-result helper
  Future<Journal?> _querySingle({
    required String where,
    required List<Object?> whereArgs,
  }) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: where,
      whereArgs: whereArgs,
      limit: 1,
    );

    if (maps.isEmpty) return null;
    return JournalEntityMapper.mapToJournal(maps.first);
  }

  // Insert a new journal
  Future<int> insert(Journal journal) async {
    final db = await _databaseHelper.database;
    final data = JournalEntityMapper.journalToMap(journal);
    return await db.insert(tableName, data);
  }

  // Update an existing journal
  Future<int> update(Journal journal) async {
    final db = await _databaseHelper.database;
    final data = JournalEntityMapper.journalToUpdateMap(journal);

    return await db.update(
      tableName,
      data,
      where: '$columnId = ?',
      whereArgs: [int.parse(journal.id)],
    );
  }

  // Delete a journal by ID
  Future<int> deleteById(String id) async {
    final db = await _databaseHelper.database;
    return await db.delete(
      tableName,
      where: '$columnId = ?',
      whereArgs: [int.parse(id)],
    );
  }

  // Get journal by ID
  Future<Journal?> findById(String id) async {
    return _querySingle(where: '$columnId = ?', whereArgs: [int.parse(id)]);
  }

  // Get all journals ordered by creation date
  Future<List<Journal>> findAll() async {
    return _queryJournals();
  }

  // Get favorite journals
  Future<List<Journal>> findFavorites() async {
    return _queryJournals(where: '$columnIsFavorite = ?', whereArgs: const [1]);
  }

  // Search journals by title or content
  Future<List<Journal>> search(String query) async {
    return _queryJournals(
      where: '$columnTitle LIKE ? OR $columnContent LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );
  }

  // Get journals by tag
  Future<List<Journal>> findByTag(String tag) async {
    return _queryJournals(where: '$columnTags LIKE ?', whereArgs: ['%$tag%']);
  }

  // Get journals created between dates
  Future<List<Journal>> findByDateRange(DateTime start, DateTime end) async {
    return _queryJournals(
      where: '$columnCreatedAt BETWEEN ? AND ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
    );
  }

  // Get journal count
  Future<int> getCount() async {
    final db = await _databaseHelper.database;
    final result = await db.rawQuery('SELECT COUNT(*) FROM $tableName');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Batch insert multiple journals
  Future<void> insertBatch(List<Journal> journals) async {
    final db = await _databaseHelper.database;
    final batch = db.batch();

    for (final journal in journals) {
      final data = JournalEntityMapper.journalToMap(journal);
      batch.insert(tableName, data);
    }

    await batch.commit(noResult: true);
  }

  // Toggle favorite status
  Future<int> toggleFavorite(String id, bool isFavorite) async {
    final db = await _databaseHelper.database;
    return await db.update(
      tableName,
      JournalEntityMapper.favoriteUpdateMap(isFavorite),
      where: '$columnId = ?',
      whereArgs: [int.parse(id)],
    );
  }
}
