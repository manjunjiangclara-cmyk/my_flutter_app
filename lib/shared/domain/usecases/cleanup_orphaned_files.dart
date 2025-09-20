import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../core/error/failures.dart';
import '../../../core/utils/file_storage_service.dart';
import '../repositories/journal_repository.dart';

/// Use case for cleaning up orphaned image files
@injectable
class CleanupOrphanedFiles {
  final JournalRepository _journalRepository;
  final FileStorageService _fileStorageService;

  CleanupOrphanedFiles(this._journalRepository, this._fileStorageService);

  /// Clean up image files that are no longer referenced by any journal
  Future<Either<Failure, int>> call() async {
    try {
      // Get all journals to collect referenced file paths
      final journalsResult = await _journalRepository.getJournals();

      return journalsResult.fold((failure) => Left(failure), (journals) async {
        // Collect all referenced image paths
        final referencedPaths = <String>{};
        for (final journal in journals) {
          referencedPaths.addAll(journal.imagePaths);
        }

        // Clean up orphaned files
        await _fileStorageService.cleanupOrphanedFiles(
          referencedPaths.toList(),
        );

        return Right(referencedPaths.length);
      });
    } catch (e) {
      return Left(CacheFailure('Failed to cleanup orphaned files: $e'));
    }
  }
}
