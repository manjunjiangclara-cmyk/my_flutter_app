import 'package:flutter/material.dart';
import 'package:my_flutter_app/features/memory/presentation/models/memory_card_model.dart';

/// Manages the list of memories and current UI state.
class MemoryData extends ChangeNotifier {
  final List<MemoryCardModel> _memories = <MemoryCardModel>[
    MemoryCardModel(
      journalId: 'journal_1',
      date: 'Thu, August 28',
      location: 'Melbourne',
      tags: <String>['Life', 'Travel'],
      description:
          'Praeterea, ex culpa non invenies unum aut non accusatis unum. Et nihil inuitam. Nemo nocere tibi erit, et non inimicos, et ne illa',
    ),
    MemoryCardModel(
      journalId: 'journal_2',
      date: 'Wed, August 27',
      location: 'Melbourne',
      tags: <String>['Life', 'Travel'],
      description:
          'Praeterea, ex culpa non invenies unum aut non accusatis unum. Et nihil inuitam. Nemo nocere tibi erit, et non inimicos, et ne illa',
    ),
    MemoryCardModel(
      journalId: 'journal_3',
      date: 'Tue, August 26',
      location: 'Sydney',
      tags: <String>['Work', 'Conference'],
      description:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
    ),
    MemoryCardModel(
      journalId: 'journal_4',
      date: 'Mon, August 25',
      location: 'Brisbane',
      tags: <String>['Friends', 'Adventure'],
      description:
          'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
    ),
  ];

  /// Represents a single memory entry with its details.
  List<MemoryCardModel> get memories => _memories;
}
