import 'package:injectable/injectable.dart';
import 'package:my_flutter_app/core/database/migration_service.dart';

/// Service for handling app initialization tasks
@injectable
class AppInitializationService {
  final MigrationService _migrationService;

  AppInitializationService(this._migrationService);

  /// Initialize the app with all necessary setup tasks
  Future<void> initializeApp() async {
    print('🚀 Starting app initialization...');

    try {
      // Run database migrations
      await _migrationService.runMigrations();

      // Clean up orphaned images (optional, can be done in background)
      _migrationService.cleanupOrphanedImages().catchError((e) {
        print('⚠️ Orphaned image cleanup failed: $e');
      });

      print('✅ App initialization completed');
    } catch (e) {
      print('❌ App initialization failed: $e');
      // Don't throw - let the app continue even if initialization fails
    }
  }

  /// Get app initialization status and statistics
  Future<Map<String, dynamic>> getInitializationStatus() async {
    try {
      final migrationStats = await _migrationService.getMigrationStats();

      return {'migrationStats': migrationStats, 'status': 'completed'};
    } catch (e) {
      return {'status': 'error', 'error': e.toString()};
    }
  }
}

