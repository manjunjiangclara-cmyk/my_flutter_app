import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/journal.dart';
import '../repositories/journal_repository.dart';

class GetJournalById implements UseCase<Journal, GetJournalByIdParams> {
  final JournalRepository repository;

  GetJournalById(this.repository);

  @override
  Future<Either<Failure, Journal>> call(GetJournalByIdParams params) async {
    return await repository.getJournalById(params.id);
  }
}

class GetJournalByIdParams {
  final String id;
  const GetJournalByIdParams(this.id);
}
