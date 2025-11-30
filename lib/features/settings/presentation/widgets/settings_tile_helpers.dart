import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';

Widget settingsLeadingIcon(
  BuildContext context, {
  required IconData icon,
  required bool enabled,
}) {
  final theme = Theme.of(context);
  return Container(
    width: UIConstants.settingsTileIconContainerSize,
    height: UIConstants.settingsTileIconContainerSize,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: enabled
          ? theme.colorScheme.primaryContainer.withOpacity(
              UIConstants.settingsTileIconBackgroundOpacity,
            )
          : theme.colorScheme.surfaceContainerHighest.withOpacity(
              UIConstants.settingsTileIconBackgroundOpacity * 0.5,
            ),
    ),
    child: Center(
      child: Icon(
        icon,
        size: UIConstants.settingsTileIconSize,
        color: enabled
            ? theme.colorScheme.primary.withValues(
                alpha: UIConstants.dockedBarUnselectedTextOpacity,
              )
            : theme.colorScheme.primary.withValues(
                alpha: UIConstants.dockedBarUnselectedTextOpacity * 0.5,
              ),
      ),
    ),
  );
}
