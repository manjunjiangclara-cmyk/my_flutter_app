import 'package:flutter/material.dart';
import 'package:my_flutter_app/features/journal/presentation/strings/journal_strings.dart';

/// Delete confirmation dialog for journal
class JournalDeleteDialog {
  static Future<bool?> show(
    BuildContext context, {
    required String journalId,
    required VoidCallback onConfirm,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(JournalStrings.deleteJournalTitle),
          content: const Text(JournalStrings.deleteJournalMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(JournalStrings.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
                onConfirm();
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text(JournalStrings.deleteJournal),
            ),
          ],
        );
      },
    );
  }
}
