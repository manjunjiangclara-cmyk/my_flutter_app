import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/fonts.dart';

TextStyle settingsTitleTextStyle(
  BuildContext context, {
  required bool enabled,
}) {
  final theme = Theme.of(context);
  return AppTypography.labelMedium.copyWith(
    color: enabled ? theme.colorScheme.onSurfaceVariant : theme.disabledColor,
  );
}

TextStyle settingsSubtitleTextStyle(
  BuildContext context, {
  required bool enabled,
}) {
  final theme = Theme.of(context);
  return AppTypography.labelSmall.copyWith(
    color: enabled
        ? theme.colorScheme.onSurface.withOpacity(0.6)
        : theme.disabledColor,
  );
}
