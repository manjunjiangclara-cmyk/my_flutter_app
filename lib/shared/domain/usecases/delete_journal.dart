import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../../core/usecase/usecase.dart';
import '../repositories/journal_repository.dart';

class DeleteJournal implements UseCase<bool, DeleteJournalParams> {
  final JournalRepository repository;

  DeleteJournal(this.repository);

  @override
  Future<Either<Failure, bool>> call(DeleteJournalParams params) async {
    return await repository.deleteJournal(params.id);
  }
}

class DeleteJournalParams {
  final String id;

  DeleteJournalParams(this.id);
}
