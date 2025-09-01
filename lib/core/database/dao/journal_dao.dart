import 'package:sqflite/sqflite.dart';

import '../../../../features/journal/domain/entities/journal.dart';
import '../database_constants.dart';
import '../database_helper.dart';
import '../mapper/journal_entity_mapper.dart';

class JournalDao {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

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
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: '$columnId = ?',
      whereArgs: [int.parse(id)],
    );

    if (maps.isEmpty) return null;
    return JournalEntityMapper.mapToJournal(maps.first);
  }

  // Get all journals ordered by creation date
  Future<List<Journal>> findAll() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      orderBy: '$columnCreatedAt DESC',
      limit: DatabaseConstants.defaultQueryLimit,
    );

    return JournalEntityMapper.mapToJournalList(maps);
  }

  // Get favorite journals
  Future<List<Journal>> findFavorites() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: '$columnIsFavorite = ?',
      whereArgs: [1],
      orderBy: '$columnCreatedAt DESC',
      limit: DatabaseConstants.defaultQueryLimit,
    );

    return JournalEntityMapper.mapToJournalList(maps);
  }

  // Search journals by title or content
  Future<List<Journal>> search(String query) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: '$columnTitle LIKE ? OR $columnContent LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: '$columnCreatedAt DESC',
      limit: DatabaseConstants.defaultQueryLimit,
    );

    return JournalEntityMapper.mapToJournalList(maps);
  }

  // Get journals by tag
  Future<List<Journal>> findByTag(String tag) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: '$columnTags LIKE ?',
      whereArgs: ['%$tag%'],
      orderBy: '$columnCreatedAt DESC',
      limit: DatabaseConstants.defaultQueryLimit,
    );

    return JournalEntityMapper.mapToJournalList(maps);
  }

  // Get journals created between dates
  Future<List<Journal>> findByDateRange(DateTime start, DateTime end) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: '$columnCreatedAt BETWEEN ? AND ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
      orderBy: '$columnCreatedAt DESC',
      limit: DatabaseConstants.defaultQueryLimit,
    );

    return JournalEntityMapper.mapToJournalList(maps);
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
      {columnIsFavorite: isFavorite ? 1 : 0},
      where: '$columnId = ?',
      whereArgs: [int.parse(id)],
    );
  }
}
