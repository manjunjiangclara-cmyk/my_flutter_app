import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/strings.dart';

class ComposeDialogs {
  ComposeDialogs._();

  /// Shows a dialog for adding a location
  static Future<void> showLocationDialog({
    required BuildContext context,
    required TextEditingController controller,
    required FocusNode focusNode,
    required Function(String) onAdd,
  }) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.addLocation),
        content: TextField(
          controller: controller,
          focusNode: focusNode,
          decoration: const InputDecoration(
            hintText: AppStrings.searchLocationHint,
            border: OutlineInputBorder(),
          ),
          onSubmitted: (value) {
            if (value.trim().isNotEmpty) {
              onAdd(value);
              Navigator.of(context).pop();
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                onAdd(controller.text);
                Navigator.of(context).pop();
              }
            },
            child: const Text(AppStrings.ok),
          ),
        ],
      ),
    );
  }

  /// Shows a dialog for adding a tag
  static Future<void> showTagDialog({
    required BuildContext context,
    required TextEditingController controller,
    required FocusNode focusNode,
    required Function(String) onAdd,
    required List<String> existingTags,
  }) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.addTag),
        content: TextField(
          controller: controller,
          focusNode: focusNode,
          decoration: const InputDecoration(
            hintText: AppStrings.enterTagHint,
            border: OutlineInputBorder(),
            prefixText: '#',
          ),
          onSubmitted: (value) {
            if (value.trim().isNotEmpty &&
                !existingTags.contains(value.trim())) {
              onAdd(value);
              Navigator.of(context).pop();
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty &&
                  !existingTags.contains(controller.text.trim())) {
                onAdd(controller.text);
                Navigator.of(context).pop();
              }
            },
            child: const Text(AppStrings.ok),
          ),
        ],
      ),
    );
  }
}
