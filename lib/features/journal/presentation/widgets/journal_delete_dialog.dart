import 'package:flutter/material.dart';
import 'package:my_flutter_app/features/journal/presentation/widgets/journal_delete_bottom_sheet.dart';

/// Delete confirmation dialog for journal
///
/// Now uses a bottom sheet instead of a dialog for better mobile UX
class JournalDeleteDialog {
  static Future<bool?> show(
    BuildContext context, {
    required String journalId,
    required VoidCallback onConfirm,
  }) {
    return JournalDeleteBottomSheet.show(
      context,
      journalId: journalId,
      onConfirm: onConfirm,
    );
  }
}
