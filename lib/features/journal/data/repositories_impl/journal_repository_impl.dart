import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/journal.dart';
import '../../domain/repositories/journal_repository.dart';
import '../datasources/journal_local_datasource.dart';

@injectable
class JournalRepositoryImpl implements JournalRepository {
  final JournalLocalDataSource localDataSource;

  JournalRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Journal>>> getJournals() async {
    try {
      final localJournals = await localDataSource.getJournals();
      return Right(localJournals);
    } catch (e) {
      return Left(CacheFailure('Failed to get journals: $e'));
    }
  }

  @override
  Future<Either<Failure, Journal>> getJournalById(String id) async {
    try {
      final journal = await localDataSource.getJournalById(id);
      if (journal != null) {
        return Right(journal);
      }
      return Left(NotFoundFailure('Journal not found'));
    } catch (e) {
      return Left(CacheFailure('Failed to get journal: $e'));
    }
  }

  @override
  Future<Either<Failure, Journal>> createJournal(Journal journal) async {
    try {
      await localDataSource.cacheJournal(journal);
      return Right(journal);
    } catch (e) {
      return Left(CacheFailure('Failed to create journal: $e'));
    }
  }

  @override
  Future<Either<Failure, Journal>> updateJournal(Journal journal) async {
    try {
      await localDataSource.cacheJournal(journal);
      return Right(journal);
    } catch (e) {
      return Left(CacheFailure('Failed to update journal: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteJournal(String id) async {
    try {
      await localDataSource.deleteJournal(id);
      return Right(true);
    } catch (e) {
      return Left(CacheFailure('Failed to delete journal: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Journal>>> searchJournals(String query) async {
    try {
      final journals = await localDataSource.searchJournals(query);
      return Right(journals);
    } catch (e) {
      return Left(CacheFailure('Failed to search journals: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Journal>>> getJournalsByTag(String tag) async {
    try {
      final journals = await localDataSource.getJournalsByTag(tag);
      return Right(journals);
    } catch (e) {
      return Left(CacheFailure('Failed to get journals by tag: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Journal>>> getFavoriteJournals() async {
    try {
      final journals = await localDataSource.getFavoriteJournals();
      return Right(journals);
    } catch (e) {
      return Left(CacheFailure('Failed to get favorite journals: $e'));
    }
  }
}
