import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/journal.dart';

abstract class JournalRepository {
  Future<Either<Failure, List<Journal>>> getJournals();
  Future<Either<Failure, Journal>> getJournalById(String id);
  Future<Either<Failure, Journal>> createJournal(Journal journal);
  Future<Either<Failure, Journal>> updateJournal(Journal journal);
  Future<Either<Failure, bool>> deleteJournal(String id);
  Future<Either<Failure, List<Journal>>> searchJournals(String query);
  Future<Either<Failure, List<Journal>>> getJournalsByTag(String tag);
  Future<Either<Failure, List<Journal>>> getFavoriteJournals();
}
