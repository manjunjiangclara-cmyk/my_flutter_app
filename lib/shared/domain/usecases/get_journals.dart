import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../../core/usecase/usecase.dart';
import '../entities/journal.dart';
import '../repositories/journal_repository.dart';

class GetJournals implements UseCase<List<Journal>, NoParams> {
  final JournalRepository repository;

  GetJournals(this.repository);

  @override
  Future<Either<Failure, List<Journal>>> call(NoParams params) async {
    return await repository.getJournals();
  }
}
