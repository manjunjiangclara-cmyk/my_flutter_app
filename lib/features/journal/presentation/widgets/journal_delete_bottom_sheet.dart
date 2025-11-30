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
    final screenHeight = MediaQuery.of(context).size.height;
    return BaseBottomSheet.show<bool>(
      context: context,
      title: null,
      showHandle: true,
      height: screenHeight * UIConstants.deleteBottomSheetHeight,
      contentPadding: EdgeInsets.zero,
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
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Title and message - at the top, close together
        Padding(
          padding: const EdgeInsets.fromLTRB(
            UIConstants.defaultPadding,
            UIConstants.mediumPadding,
            UIConstants.defaultPadding,
            UIConstants.largePadding,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title
              Text(
                JournalStrings.deleteJournalTitle,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: UIConstants.defaultPadding),
              // Message - close to title
              Text(
                JournalStrings.deleteJournalMessage,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),

        const Spacer(),

        // Delete button - full width, WhatsApp style, at the bottom
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: UIConstants.defaultPadding,
          ),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop(true);
                onConfirm();
              },
              label: Text(
                AppStrings.delete,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onError,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.error,
                foregroundColor: theme.colorScheme.onError,
                minimumSize: const Size(
                  double.infinity,
                  UIConstants.deleteButtonHeight,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: UIConstants.defaultPadding,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    UIConstants.deleteButtonHeight / 2,
                  ),
                ),
                elevation: 0,
              ),
            ),
          ),
        ),
        const SizedBox(height: UIConstants.defaultPadding),
      ],
    );
  }
}
