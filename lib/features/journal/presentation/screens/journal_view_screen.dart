import 'package:flutter/material.dart';

import '../../../journal/domain/entities/journal.dart';
import '../../../journal/domain/usecases/get_journal_by_id.dart';
import '../bloc/journal_view/journal_view_bloc.dart';
import '../bloc/journal_view/journal_view_event.dart';
import '../bloc/journal_view/journal_view_state.dart';

class JournalViewScreen extends StatefulWidget {
  final String journalId;
  final GetJournalById getJournalById;

  const JournalViewScreen({
    super.key,
    required this.journalId,
    required this.getJournalById,
  });

  @override
  State<JournalViewScreen> createState() => _JournalViewScreenState();
}

class _JournalViewScreenState extends State<JournalViewScreen> {
  late final JournalViewBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = JournalViewBloc(getJournalById: widget.getJournalById);
    _bloc.add(LoadJournal(widget.journalId));
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<JournalViewState>(
      stream: _bloc.stream,
      initialData: _bloc.state,
      builder: (context, snapshot) {
        final state = snapshot.data;
        if (state is JournalLoading || state is JournalInitial) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is JournalError) {
          return Center(child: Text(state.message));
        }
        if (state is JournalLoaded) {
          final Journal journal = state.journal;
          return Scaffold(
            appBar: AppBar(title: Text(journal.title)),
            body: const SizedBox.shrink(),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
