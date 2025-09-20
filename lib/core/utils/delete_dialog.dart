import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/strings.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';

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

  if (Platform.isIOS) {
    // iOS native style with bottom action sheet
    return showCupertinoModalPopup<bool>(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.only(
          left: UIConstants.dialogPadding,
          right: UIConstants.dialogPadding,
          bottom: UIConstants.dialogPadding,
        ),
        child: CupertinoActionSheet(
          title: Text(
            title,
            style: TextStyle(
              fontSize: UIConstants.dialogFontSize,
              color: CupertinoColors.secondaryLabel,
            ),
          ),
          message: Text(
            content,
            style: TextStyle(
              fontSize: UIConstants.dialogFontSize,
              color: CupertinoColors.secondaryLabel,
            ),
          ),
          actions: [
            CupertinoActionSheetAction(
              isDestructiveAction: true,
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                AppStrings.delete,
                style: TextStyle(color: CupertinoColors.destructiveRed),
              ),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              AppStrings.cancel,
              style: TextStyle(color: CupertinoColors.activeBlue),
            ),
          ),
        ),
      ),
    );
  } else {
    // Android Material style
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              AppStrings.delete,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}
