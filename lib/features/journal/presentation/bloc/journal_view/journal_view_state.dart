import '../../../domain/entities/journal.dart';

abstract class JournalViewState {}

class JournalInitial extends JournalViewState {}

class JournalLoading extends JournalViewState {}

class JournalLoaded extends JournalViewState {
  final Journal journal;
  JournalLoaded(this.journal);
}

class JournalError extends JournalViewState {
  final String message;
  JournalError(this.message);
}


