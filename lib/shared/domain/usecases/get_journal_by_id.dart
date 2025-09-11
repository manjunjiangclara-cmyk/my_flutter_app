import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../../core/usecase/usecase.dart';
import '../entities/journal.dart';
import '../repositories/journal_repository.dart';

class GetJournalById implements UseCase<Journal, GetJournalByIdParams> {
  final JournalRepository repository;

  GetJournalById(this.repository);

  final mockJournal = Journal(
    id: 'mock-journal-001',
    title: 'A Day in the Mountains',
    content:
        '''The crisp morning air filled my lungs as I began the ascent up Eagle Peak. The trail wound through ancient pine forests, their branches creating a natural cathedral overhead. Each step brought me closer to the summit, and with it, a sense of peace I hadn't felt in weeks.

The city below seemed like a distant memory as I reached the first lookout point. The valley stretched out before me, painted in autumn colors - golds, reds, and deep greens that seemed to dance in the morning light. I sat on a weathered boulder and pulled out my journal, feeling the weight of the moment.

Sometimes we need to step away from the noise to hear our own thoughts. The mountain had a way of putting everything into perspective. The worries that seemed so important yesterday felt small against the vastness of the landscape.

I made a promise to myself up there - to seek out these moments of clarity more often, to remember that there's always a bigger picture, and that sometimes the best way forward is to simply pause and breathe.

The descent was easier, not just because of gravity, but because I carried with me a renewed sense of purpose. The mountain had given me what I needed most: time to think, space to feel, and the reminder that sometimes the journey itself is the destination.''',
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
    updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    tags: ['hiking', 'nature', 'adventure', 'reflection', 'mindfulness'],
    isFavorite: true,
    imageUrls: [
      'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800',
      'https://images.unsplash.com/photo-1464822759844-d150baec0b8b?w=800',
      'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800',
    ],
  );

  @override
  Future<Either<Failure, Journal>> call(GetJournalByIdParams params) async {
    return Right(mockJournal);
    //return await repository.getJournalById(params.id);
  }
}

class GetJournalByIdParams {
  final String id;
  const GetJournalByIdParams(this.id);
}
