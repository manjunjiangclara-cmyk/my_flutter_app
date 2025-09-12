import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../core/error/failures.dart';
import '../../../core/usecase/usecase.dart';
import '../entities/journal.dart';
import '../repositories/journal_repository.dart';

@injectable
class UpdateJournal implements UseCase<Journal, UpdateJournalParams> {
  final JournalRepository repository;

  UpdateJournal(this.repository);

  @override
  Future<Either<Failure, Journal>> call(UpdateJournalParams params) async {
    return await repository.updateJournal(params.journal);
  }
}

class UpdateJournalParams {
  final Journal journal;

  UpdateJournalParams(this.journal);
}
