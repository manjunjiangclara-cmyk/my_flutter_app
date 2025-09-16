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
    // return await repository.getJournals();
    // Mock data with entries from different months for testing memory grouping
    final mockJournals = _generateMockJournals();
    return Right(mockJournals);
  }

  /// Generates mock journal data with entries from different months
  List<Journal> _generateMockJournals() {
    return [
      // August 2024 entries
      Journal(
        id: '1',
        content:
            'Had an amazing day at the beach with friends. The sunset was absolutely breathtaking and we had a great time building sandcastles.',
        createdAt: DateTime(2024, 8, 15, 14, 30),
        updatedAt: DateTime(2024, 8, 15, 14, 30),
        tags: ['beach', 'friends', 'sunset', 'summer'],
        isFavorite: true,
        imageUrls: [
          'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800&h=600&fit=crop',
        ],
        location: 'Santa Monica Beach',
      ),
      Journal(
        id: '2',
        content:
            'Tried a new restaurant downtown. The pasta was incredible and the atmosphere was perfect for a date night.',
        createdAt: DateTime(2024, 8, 22, 19, 45),
        updatedAt: DateTime(2024, 8, 22, 19, 45),
        tags: ['food', 'restaurant', 'date', 'pasta'],
        isFavorite: false,
        imageUrls: [],
        location: 'Downtown Restaurant',
      ),
      Journal(
        id: '3',
        content:
            'Completed my first 5K run! Feeling proud and motivated to keep up with my fitness goals.',
        createdAt: DateTime(2024, 8, 28, 8, 15),
        updatedAt: DateTime(2024, 8, 28, 8, 15),
        tags: ['fitness', 'running', 'achievement', 'health'],
        isFavorite: true,
        imageUrls: [
          'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=800&h=600&fit=crop',
        ],
        location: 'Central Park',
      ),

      // September 2024 entries
      Journal(
        id: '4',
        content:
            'Started learning a new programming language today. The syntax is challenging but exciting!',
        createdAt: DateTime(2024, 9, 5, 10, 20),
        updatedAt: DateTime(2024, 9, 5, 10, 20),
        tags: ['programming', 'learning', 'technology', 'coding'],
        isFavorite: false,
        imageUrls: [],
        location: 'Home Office',
      ),
      Journal(
        id: '5',
        content:
            'Visited the art museum with my family. The contemporary art exhibition was thought-provoking and inspiring.',
        createdAt: DateTime(2024, 9, 12, 15, 30),
        updatedAt: DateTime(2024, 9, 12, 15, 30),
        tags: ['art', 'museum', 'family', 'culture'],
        isFavorite: true,
        imageUrls: [
          'https://images.unsplash.com/photo-1541961017774-22349e4a1262?w=800&h=600&fit=crop',
          'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800&h=600&fit=crop',
        ],
        location: 'Modern Art Museum',
      ),
      Journal(
        id: '6',
        content:
            'Cooked a delicious homemade pizza from scratch. The dough turned out perfect and the toppings were fresh from the garden.',
        createdAt: DateTime(2024, 9, 18, 18, 45),
        updatedAt: DateTime(2024, 9, 18, 18, 45),
        tags: ['cooking', 'pizza', 'homemade', 'garden'],
        isFavorite: false,
        imageUrls: [
          'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=800&h=600&fit=crop',
        ],
        location: 'Home Kitchen',
      ),

      // October 2024 entries
      Journal(
        id: '7',
        content:
            'Went hiking in the mountains this weekend. The fall colors were absolutely stunning and the air was so fresh.',
        createdAt: DateTime(2024, 10, 3, 9, 0),
        updatedAt: DateTime(2024, 10, 3, 9, 0),
        tags: ['hiking', 'mountains', 'nature', 'fall', 'weekend'],
        isFavorite: true,
        imageUrls: [
          'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800&h=600&fit=crop',
          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&h=600&fit=crop',
        ],
        location: 'Mountain Trail',
      ),
      Journal(
        id: '8',
        content:
            'Attended a jazz concert at the local venue. The musicians were incredibly talented and the atmosphere was electric.',
        createdAt: DateTime(2024, 10, 10, 20, 0),
        updatedAt: DateTime(2024, 10, 10, 20, 0),
        tags: ['music', 'jazz', 'concert', 'entertainment'],
        isFavorite: false,
        imageUrls: [],
        location: 'Jazz Club',
      ),
      Journal(
        id: '9',
        content:
            'Celebrated my birthday with close friends. We had a small gathering at home with cake and good conversation.',
        createdAt: DateTime(2024, 10, 15, 19, 30),
        updatedAt: DateTime(2024, 10, 15, 19, 30),
        tags: ['birthday', 'friends', 'celebration', 'home'],
        isFavorite: true,
        imageUrls: [
          'https://images.unsplash.com/photo-1464349095431-e9ad2126a4c9?w=800&h=600&fit=crop',
        ],
        location: 'Home',
      ),

      // November 2024 entries
      Journal(
        id: '10',
        content:
            'Started reading a new book series. The first chapter was captivating and I can\'t wait to continue.',
        createdAt: DateTime(2024, 11, 2, 21, 15),
        updatedAt: DateTime(2024, 11, 2, 21, 15),
        tags: ['reading', 'books', 'literature', 'entertainment'],
        isFavorite: false,
        imageUrls: [],
        location: 'Living Room',
      ),
      Journal(
        id: '11',
        content:
            'Volunteered at the local food bank today. It was rewarding to help the community and meet new people.',
        createdAt: DateTime(2024, 11, 8, 13, 0),
        updatedAt: DateTime(2024, 11, 8, 13, 0),
        tags: ['volunteering', 'community', 'helping', 'charity'],
        isFavorite: true,
        imageUrls: [],
        location: 'Community Food Bank',
      ),

      // December 2024 entries
      Journal(
        id: '12',
        content:
            'Decorated the house for the holidays. The Christmas tree looks beautiful and the whole place feels festive.',
        createdAt: DateTime(2024, 12, 1, 16, 30),
        updatedAt: DateTime(2024, 12, 1, 16, 30),
        tags: ['holidays', 'christmas', 'decorating', 'family'],
        isFavorite: true,
        imageUrls: [
          'https://images.unsplash.com/photo-1512389142860-9c449e58a543?w=800&h=600&fit=crop',
        ],
        location: 'Home',
      ),
      Journal(
        id: '13',
        content:
            'Had a cozy winter evening with hot chocolate and a movie. Perfect way to end a cold day.',
        createdAt: DateTime(2024, 12, 8, 20, 45),
        updatedAt: DateTime(2024, 12, 8, 20, 45),
        tags: ['winter', 'cozy', 'movie', 'relaxation'],
        isFavorite: false,
        imageUrls: [],
        location: 'Living Room',
      ),

      // January 2025 entries (current year)
      Journal(
        id: '14',
        content:
            'New Year\'s resolution: Start a daily meditation practice. Day 1 was challenging but I feel more centered already.',
        createdAt: DateTime(2025, 1, 1, 7, 0),
        updatedAt: DateTime(2025, 1, 1, 7, 0),
        tags: ['new year', 'meditation', 'resolution', 'wellness'],
        isFavorite: true,
        imageUrls: [],
        location: 'Home',
      ),
      Journal(
        id: '15',
        content:
            'Went ice skating for the first time this winter. I fell a few times but had a lot of fun learning.',
        createdAt: DateTime(2025, 1, 5, 14, 20),
        updatedAt: DateTime(2025, 1, 5, 14, 20),
        tags: ['winter', 'ice skating', 'learning', 'fun'],
        isFavorite: false,
        imageUrls: [
          'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=800&h=600&fit=crop',
        ],
        location: 'Ice Rink',
      ),
      Journal(
        id: '16',
        content:
            'Tried a new coffee shop in the neighborhood. The latte art was impressive and the atmosphere was perfect for working.',
        createdAt: DateTime(2025, 1, 12, 10, 30),
        updatedAt: DateTime(2025, 1, 12, 10, 30),
        tags: ['coffee', 'work', 'cafe', 'atmosphere'],
        isFavorite: false,
        imageUrls: [],
        location: 'Local Coffee Shop',
      ),
    ];
  }
}
