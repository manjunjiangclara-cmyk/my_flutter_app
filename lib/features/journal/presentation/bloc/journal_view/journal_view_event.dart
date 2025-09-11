import 'package:equatable/equatable.dart';

abstract class JournalViewEvent extends Equatable {
  const JournalViewEvent();

  @override
  List<Object?> get props => [];
}

class LoadJournal extends JournalViewEvent {
  final String id;

  const LoadJournal(this.id);

  @override
  List<Object?> get props => [id];
}
