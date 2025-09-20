import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../core/error/failures.dart';
import '../../../core/utils/usecase.dart';
import '../entities/journal.dart';
import '../repositories/journal_repository.dart';

@injectable
class GetJournals implements UseCase<List<Journal>, NoParams> {
  final JournalRepository repository;

  GetJournals(this.repository);

  @override
  Future<Either<Failure, List<Journal>>> call(NoParams params) async {
    return await repository.getJournals();
    // Mock data with entries from different months for testing memory grouping
    // final mockJournals = _generateMockJournals();
    // return Right(mockJournals);
  }
}
