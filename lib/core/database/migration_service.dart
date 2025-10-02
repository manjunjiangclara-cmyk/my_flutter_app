import 'package:injectable/injectable.dart';
import 'package:my_flutter_app/core/database/database_helper.dart';
import 'package:my_flutter_app/core/database/mapper/journal_entity_mapper.dart';
import 'package:my_flutter_app/core/utils/image_path_migration_service.dart';
import 'package:my_flutter_app/shared/domain/entities/journal.dart';

/// Service for handling database migrations
@injectable
class MigrationService {
  final DatabaseHelper _databaseHelper;
  final ImagePathMigrationService _imagePathMigrationService;

  MigrationService(this._databaseHelper, this._imagePathMigrationService);

  /// Run all pending migrations
  Future<void> runMigrations() async {
    print('🔄 Starting database migrations...');

    await _migrateImagePaths();

    print('✅ Database migrations completed');
  }

  /// Migrate invalid image paths in the database
  Future<void> _migrateImagePaths() async {
    try {
      print('🖼️ Starting image path migration...');

      final db = await _databaseHelper.database;

      // Get all journals with image paths
      final journals = await db.query(
        'journals',
        where: 'image_paths IS NOT NULL AND image_paths != ?',
        whereArgs: [''],
      );

      int migratedCount = 0;
      int invalidCount = 0;

      for (final journalData in journals) {
        final journal = JournalEntityMapper.mapToJournal(journalData);

        if (journal.imagePaths.isNotEmpty) {
          // Validate and fix image paths
          final validImagePaths = await _imagePathMigrationService
              .validateAndFixJournalImagePaths(journal.imagePaths);

          // Update the journal if paths changed
          if (validImagePaths.length != journal.imagePaths.length ||
              !_arePathsEqual(journal.imagePaths, validImagePaths)) {
            final updatedJournal = Journal(
              id: journal.id,
              content: journal.content,
              createdAt: journal.createdAt,
              updatedAt: DateTime.now(),
              isFavorite: journal.isFavorite,
              tags: journal.tags,
              imagePaths: validImagePaths,
              location: journal.location,
            );

            await db.update(
              'journals',
              JournalEntityMapper.journalToUpdateMap(updatedJournal),
              where: 'id = ?',
              whereArgs: [journal.id],
            );

            final lostImages =
                journal.imagePaths.length - validImagePaths.length;
            if (lostImages > 0) {
              invalidCount += lostImages;
              print('⚠️ Journal ${journal.id}: Lost $lostImages images');
            } else {
              migratedCount += journal.imagePaths.length;
              print(
                '✅ Journal ${journal.id}: Migrated ${journal.imagePaths.length} images',
              );
            }
          }
        }
      }

      print('🖼️ Image path migration completed:');
      print('   - Migrated: $migratedCount images');
      print('   - Lost: $invalidCount images');
    } catch (e) {
      print('❌ Error during image path migration: $e');
    }
  }

  /// Check if two path lists are equal
  bool _arePathsEqual(List<String> paths1, List<String> paths2) {
    if (paths1.length != paths2.length) return false;

    for (int i = 0; i < paths1.length; i++) {
      if (paths1[i] != paths2[i]) return false;
    }

    return true;
  }

  /// Clean up orphaned image files
  Future<void> cleanupOrphanedImages() async {
    try {
      print('🗑️ Starting orphaned image cleanup...');

      final db = await _databaseHelper.database;

      // Get all referenced image paths
      final journals = await db.query('journals');
      final referencedPaths = <String>[];

      for (final journalData in journals) {
        final journal = JournalEntityMapper.mapToJournal(journalData);
        referencedPaths.addAll(journal.imagePaths);
      }

      // Clean up orphaned files
      final orphanedFiles = await _imagePathMigrationService
          .cleanupOrphanedImages(referencedPaths);

      print('🗑️ Orphaned image cleanup completed:');
      print('   - Removed: ${orphanedFiles.length} files');
    } catch (e) {
      print('❌ Error during orphaned image cleanup: $e');
    }
  }

  /// Get migration statistics
  Future<Map<String, int>> getMigrationStats() async {
    try {
      final db = await _databaseHelper.database;

      // Count journals with images
      final journalsWithImages = await db.rawQuery(
        'SELECT COUNT(*) as count FROM journals WHERE image_paths IS NOT NULL AND image_paths != ?',
        [''],
      );

      // Count total image references
      final journals = await db.query('journals');
      int totalImageReferences = 0;
      int validImageReferences = 0;

      for (final journalData in journals) {
        final journal = JournalEntityMapper.mapToJournal(journalData);
        totalImageReferences += journal.imagePaths.length;

        for (final imagePath in journal.imagePaths) {
          if (await _imagePathMigrationService.isImagePathValid(imagePath)) {
            validImageReferences++;
          }
        }
      }

      return {
        'journalsWithImages': journalsWithImages.first['count'] as int,
        'totalImageReferences': totalImageReferences,
        'validImageReferences': validImageReferences,
        'invalidImageReferences': totalImageReferences - validImageReferences,
      };
    } catch (e) {
      print('❌ Error getting migration stats: $e');
      return {};
    }
  }
}

