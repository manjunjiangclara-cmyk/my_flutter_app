import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_flutter_app/core/di/injection.dart';
import 'package:my_flutter_app/core/strings.dart';
import 'package:my_flutter_app/features/compose/presentation/bloc/location_picker/location_picker_bloc.dart';
import 'package:my_flutter_app/features/compose/presentation/models/location_search_models.dart';
import 'package:my_flutter_app/features/compose/presentation/widgets/location/location_picker_bottom_sheet.dart';

class ComposeDialogs {
  ComposeDialogs._();

  /// Shows a bottom sheet for adding a location with search functionality
  static Future<void> showLocationDialog({
    required BuildContext context,
    required TextEditingController controller,
    required FocusNode focusNode,
    required Function(LocationSearchResult) onAdd,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocProvider(
        create: (context) => getIt<LocationPickerBloc>(),
        child: LocationPickerBottomSheet(
          onLocationSelected: (location) {
            controller.text = location.name;
            onAdd(location);
          },
        ),
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
