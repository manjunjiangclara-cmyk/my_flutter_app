import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'dao/journal_dao.dart';
import 'database_constants.dart';

@singleton
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();

    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(
      await getDatabasesPath(),
      DatabaseConstants.databaseName,
    );
    return await openDatabase(
      path,
      version: DatabaseConstants.databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create journals table
    await db.execute(JournalDao.createTableSQL);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database schema upgrades here
    if (oldVersion < 2) {
      // Add location columns for version 2
      await db.execute(JournalDao.addLocationColumnsSQL);
    }
  }

  // Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }

  // Get database instance
  static DatabaseHelper get instance => _instance;
}
