import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/strings.dart';
import 'package:my_flutter_app/shared/presentation/dialogs/blur_confirm_dialog.dart';

/// Shows a cross-platform delete confirmation dialog
///
/// Automatically displays different styles for iOS/Android platforms
///
/// [context] - BuildContext
/// [itemName] - Name of the item to delete, optional
///
/// Returns [bool?] - true for confirm delete, false for cancel, null if dialog was dismissed
Future<bool?> showDeleteDialog(BuildContext context, {String? itemName}) {
  final title = itemName != null
      ? "Delete $itemName?"
      : AppStrings.deleteConfirmTitle;
  final content = itemName != null
      ? "This action cannot be undone. Are you sure you want to delete?"
      : AppStrings.deleteConfirmMessage;

  // Unified custom blur dialog for all platforms
  return showBlurConfirmDialog(
    context,
    title: title,
    message: content,
    confirmText: AppStrings.delete,
    cancelText: AppStrings.cancel,
  );
}
