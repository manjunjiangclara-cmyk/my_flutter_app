import 'package:sqflite/sqflite.dart';

import '../database_constants.dart';
import '../database_helper.dart';

class TagDao {
  final DatabaseHelper _databaseHelper;

  TagDao([DatabaseHelper? databaseHelper])
    : _databaseHelper = databaseHelper ?? DatabaseHelper.instance;

  // Table names
  static const String tagsTable = DatabaseConstants.tagsTable;
  static const String journalTagsTable = DatabaseConstants.journalTagsTable;

  // Column names
  static const String tagId = DatabaseConstants.tagId;
  static const String tagName = DatabaseConstants.tagName;
  static const String tagColor = DatabaseConstants.tagColor;
  static const String tagCreatedAt = DatabaseConstants.tagCreatedAt;
  static const String jtJournalId = DatabaseConstants.journalTagJournalId;
  static const String jtTagId = DatabaseConstants.journalTagTagId;

  // Create tables SQL
  static const String createTagsTableSQL =
      '''
    CREATE TABLE IF NOT EXISTS $tagsTable (
      $tagId INTEGER PRIMARY KEY AUTOINCREMENT,
      $tagName TEXT NOT NULL UNIQUE,
      $tagColor TEXT,
      $tagCreatedAt TEXT NOT NULL
    )
  ''';

  static const String createJournalTagsTableSQL =
      '''
    CREATE TABLE IF NOT EXISTS $journalTagsTable (
      $jtJournalId INTEGER NOT NULL,
      $jtTagId INTEGER NOT NULL,
      PRIMARY KEY ($jtJournalId, $jtTagId)
    )
  ''';

  static const String createJournalTagsJournalIndexSQL =
      'CREATE INDEX IF NOT EXISTS idx_journal_tags_journal ON $journalTagsTable($jtJournalId)';

  static const String createJournalTagsTagIndexSQL =
      'CREATE INDEX IF NOT EXISTS idx_journal_tags_tag ON $journalTagsTable($jtTagId)';

  Future<List<String>> getTags({String? filter, int? limit}) async {
    final db = await _databaseHelper.database;
    final where = (filter != null && filter.trim().isNotEmpty)
        ? '$tagName LIKE ?'
        : null;
    final whereArgs = (filter != null && filter.trim().isNotEmpty)
        ? ['%${filter.trim()}%']
        : null;
    final maps = await db.query(
      tagsTable,
      columns: [tagName],
      where: where,
      whereArgs: whereArgs,
      orderBy: '$tagName COLLATE NOCASE ASC',
      limit: limit,
    );
    return maps.map((m) => m[tagName] as String).toList();
  }

  Future<int> insertOrGetTagId(String name, {String? color}) async {
    final db = await _databaseHelper.database;
    final normalized = name.trim();
    if (normalized.isEmpty) return -1;

    // Try to insert; on conflict, fetch existing id
    try {
      final id = await db.insert(tagsTable, {
        tagName: normalized,
        tagColor: color,
        tagCreatedAt: DateTime.now().toIso8601String(),
      });
      return id;
    } catch (_) {
      final existing = await db.query(
        tagsTable,
        columns: [tagId],
        where: '$tagName = ?',
        whereArgs: [normalized],
        limit: 1,
      );
      if (existing.isNotEmpty) {
        return existing.first[tagId] as int;
      }
      rethrow;
    }
  }

  Future<void> linkJournalTag(int journalId, int tagIdValue) async {
    final db = await _databaseHelper.database;
    await db.insert(journalTagsTable, {
      jtJournalId: journalId,
      jtTagId: tagIdValue,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<void> unlinkAllTagsForJournal(int journalId) async {
    final db = await _databaseHelper.database;
    await db.delete(
      journalTagsTable,
      where: '$jtJournalId = ?',
      whereArgs: [journalId],
    );
  }

  /// Efficiently upserts journal-tag mappings based on tag names.
  /// - Ensures tag rows exist (INSERT OR IGNORE)
  /// - Deletes mappings not in the provided names
  /// - Inserts any missing mappings (IGNORE on conflict)
  Future<void> upsertJournalTagsByNames(
    int journalId,
    List<String> tagNames,
  ) async {
    final db = await _databaseHelper.database;

    // Normalize and de-duplicate input
    final List<String> names = tagNames
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList();

    await db.transaction((txn) async {
      if (names.isEmpty) {
        // If no tags selected, remove all mappings for this journal
        await txn.delete(
          journalTagsTable,
          where: '$jtJournalId = ?',
          whereArgs: [journalId],
        );
        return;
      }

      // 1) Ensure tag rows exist
      final insertBatch = txn.batch();
      for (final name in names) {
        insertBatch.insert(tagsTable, {
          tagName: name,
          tagColor: null,
          tagCreatedAt: DateTime.now().toIso8601String(),
        }, conflictAlgorithm: ConflictAlgorithm.ignore);
      }
      await insertBatch.commit(noResult: true);

      // 2) Resolve ids for provided names
      // Build placeholders (?, ?, ...)
      final placeholders = List.filled(names.length, '?').join(',');
      final rows = await txn.query(
        tagsTable,
        columns: [tagId, tagName],
        where: '$tagName IN ($placeholders)',
        whereArgs: names,
      );
      final List<int> tagIds = rows.map((r) => r[tagId] as int).toList();

      if (tagIds.isEmpty) {
        // Safety: nothing resolved → clear all mappings
        await txn.delete(
          journalTagsTable,
          where: '$jtJournalId = ?',
          whereArgs: [journalId],
        );
        return;
      }

      // 3) Delete mappings that are no longer selected
      final keepPlaceholders = List.filled(tagIds.length, '?').join(',');
      await txn.delete(
        journalTagsTable,
        where: '$jtJournalId = ? AND $jtTagId NOT IN ($keepPlaceholders)',
        whereArgs: [journalId, ...tagIds],
      );

      // 4) Insert any missing mappings (IGNORE duplicates)
      final linkBatch = txn.batch();
      for (final id in tagIds) {
        linkBatch.insert(journalTagsTable, {
          jtJournalId: journalId,
          jtTagId: id,
        }, conflictAlgorithm: ConflictAlgorithm.ignore);
      }
      await linkBatch.commit(noResult: true);
    });
  }
}
