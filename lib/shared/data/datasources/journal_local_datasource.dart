import 'package:injectable/injectable.dart';

import '../../../../core/database/dao/journal_dao.dart';
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

@Injectable(as: JournalLocalDataSource)
class JournalLocalDataSourceImpl implements JournalLocalDataSource {
  final JournalDao _journalDao = JournalDao();

  @override
  Future<List<Journal>> getJournals() async {
    return await _journalDao.findAll();
  }

  @override
  Future<Journal?> getJournalById(String id) async {
    return await _journalDao.findById(id);
  }

  @override
  Future<void> cacheJournal(Journal journal) async {
    final existing = await _journalDao.findById(journal.id);
    if (existing == null) {
      // Insert new journal
      await _journalDao.insert(journal);
    } else {
      // Update existing journal
      await _journalDao.update(journal);
    }
  }

  @override
  Future<void> cacheJournals(List<Journal> journals) async {
    await _journalDao.insertBatch(journals);
  }

  @override
  Future<void> deleteJournal(String id) async {
    await _journalDao.deleteById(id);
  }

  @override
  Future<List<Journal>> searchJournals(String query) async {
    return await _journalDao.search(query);
  }

  @override
  Future<List<Journal>> getJournalsByTag(String tag) async {
    return await _journalDao.findByTag(tag);
  }

  @override
  Future<List<Journal>> getFavoriteJournals() async {
    return await _journalDao.findFavorites();
  }
}
