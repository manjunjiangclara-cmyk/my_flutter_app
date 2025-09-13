import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../core/error/failures.dart';
import '../../../core/usecase/usecase.dart';
import '../entities/journal.dart';
import '../repositories/journal_repository.dart';

@injectable
class SearchJournals implements UseCase<List<Journal>, SearchJournalsParams> {
  final JournalRepository repository;

  SearchJournals(this.repository);

  @override
  Future<Either<Failure, List<Journal>>> call(
    SearchJournalsParams params,
  ) async {
    return await repository.searchJournals(params.query);
  }
}

class SearchJournalsParams {
  final String query;

  SearchJournalsParams(this.query);
}
