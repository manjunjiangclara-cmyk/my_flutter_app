import '../../domain/entities/journal.dart';

abstract class JournalLocalDataSource {
  Future<List<Journal>> getJournals();
  Future<Journal?> getJournalById(String id);
  Future<void> cacheJournal(Journal journal);
  Future<void> cacheJournals(List<Journal> journals);
  Future<void> deleteJournal(String id);
  Future<List<Journal>> searchJournals(String query);
  Future<List<Journal>> getJournalsByTag(String tag);
  Future<List<Journal>> getFavoriteJournals();
}



