abstract class JournalViewEvent {}

class LoadJournal extends JournalViewEvent {
  final String id;
  LoadJournal(this.id);
}
