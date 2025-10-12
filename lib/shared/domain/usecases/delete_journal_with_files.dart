import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../core/error/failures.dart';
import '../../../core/utils/file_storage_service.dart';
import '../repositories/journal_repository.dart';

/// Use case for deleting a journal and its associated image files
@injectable
class DeleteJournalWithFiles {
  final JournalRepository _journalRepository;
  final FileStorageService _fileStorageService;

  DeleteJournalWithFiles(this._journalRepository, this._fileStorageService);

  /// Delete a journal and clean up its associated image files
  Future<Either<Failure, bool>> call(String journalId) async {
    try {
      // First get the journal to access its image paths
      final journalResult = await _journalRepository.getJournalById(journalId);

      return journalResult.fold((failure) => Left(failure), (journal) async {
        // Delete the journal from database
        final deleteResult = await _journalRepository.deleteJournal(journalId);

        return deleteResult.fold((failure) => Left(failure), (success) async {
          if (success && journal.imagePaths.isNotEmpty) {
            // Delete associated image files
            await _fileStorageService.deleteFiles(journal.imagePaths);
          }
          return Right(success);
        });
      });
    } catch (e) {
      return Left(CacheFailure('Failed to delete journal with files: $e'));
    }
  }
}
