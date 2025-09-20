import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/utils/delete_dialog.dart';
import 'package:my_flutter_app/features/journal/presentation/strings/journal_strings.dart';

/// Delete confirmation dialog for journal
class JournalDeleteDialog {
  static Future<bool?> show(
    BuildContext context, {
    required String journalId,
    required VoidCallback onConfirm,
  }) {
    return showDeleteDialog(context, itemName: JournalStrings.journal).then((
      confirmed,
    ) {
      if (confirmed == true) {
        onConfirm();
      }
      return confirmed;
    });
  }
}
