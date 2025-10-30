import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';

Widget settingsLeadingIcon(
  BuildContext context, {
  required IconData icon,
  required bool enabled,
}) {
  final theme = Theme.of(context);
  return SizedBox.fromSize(
    size: const Size(
      UIConstants.settingsTileIconContainerSize,
      UIConstants.settingsTileIconContainerSize,
    ),
    child: Icon(
      icon,
      size: UIConstants.settingsTileIconSize,
      color: enabled ? theme.colorScheme.primary : theme.disabledColor,
    ),
  );
}
