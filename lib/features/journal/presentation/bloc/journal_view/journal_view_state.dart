import 'package:equatable/equatable.dart';

import '../../../../../shared/domain/entities/journal.dart';

abstract class JournalViewState extends Equatable {
  const JournalViewState();

  @override
  List<Object?> get props => [];
}

class JournalInitial extends JournalViewState {
  const JournalInitial();
}

class JournalLoading extends JournalViewState {
  const JournalLoading();
}

class JournalLoaded extends JournalViewState {
  final Journal journal;

  const JournalLoaded(this.journal);

  @override
  List<Object?> get props => [journal];
}

class JournalError extends JournalViewState {
  final String message;

  const JournalError(this.message);

  @override
  List<Object?> get props => [message];
}
