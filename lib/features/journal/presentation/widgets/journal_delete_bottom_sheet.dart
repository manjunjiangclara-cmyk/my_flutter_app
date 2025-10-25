import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/strings.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
import 'package:my_flutter_app/features/journal/presentation/strings/journal_strings.dart';
import 'package:my_flutter_app/shared/presentation/widgets/base_bottom_sheet.dart';

/// Bottom sheet for journal deletion confirmation
class JournalDeleteBottomSheet {
  /// Shows a bottom sheet for journal deletion confirmation
  static Future<bool?> show(
    BuildContext context, {
    required String journalId,
    required VoidCallback onConfirm,
  }) {
    return BaseBottomSheet.show<bool>(
      context: context,
      title: JournalStrings.deleteJournalTitle,
      child: _JournalDeleteBottomSheetContent(
        journalId: journalId,
        onConfirm: onConfirm,
      ),
    );
  }
}

class _JournalDeleteBottomSheetContent extends StatelessWidget {
  final String journalId;
  final VoidCallback onConfirm;

  const _JournalDeleteBottomSheetContent({
    required this.journalId,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Message
        Text(
          JournalStrings.deleteJournalMessage,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: UIConstants.largePadding),

        // Action buttons
        Row(
          children: [
            // Cancel button
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(false),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: UIConstants.mediumPadding,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      UIConstants.defaultRadius,
                    ),
                  ),
                ),
                child: Text(
                  JournalStrings.cancel,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ),
            const SizedBox(width: UIConstants.smallPadding),

            // Delete button
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                  onConfirm();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Theme.of(context).colorScheme.onError,
                  padding: const EdgeInsets.symmetric(
                    vertical: UIConstants.mediumPadding,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      UIConstants.defaultRadius,
                    ),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  AppStrings.delete,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onError,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
