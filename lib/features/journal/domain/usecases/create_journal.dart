import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/journal.dart';
import '../repositories/journal_repository.dart';

class CreateJournal implements UseCase<Journal, CreateJournalParams> {
  final JournalRepository repository;

  CreateJournal(this.repository);

  @override
  Future<Either<Failure, Journal>> call(CreateJournalParams params) async {
    return await repository.createJournal(params.journal);
  }
}

class CreateJournalParams {
  final Journal journal;

  CreateJournalParams(this.journal);
}
