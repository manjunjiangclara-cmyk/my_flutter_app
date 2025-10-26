import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/fonts.dart';
import 'package:my_flutter_app/core/theme/spacings.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';

/// A reusable widget for displaying settings items with a switch.
class SettingsTileWithSwitch extends StatelessWidget {
  /// The icon to display for this setting.
  final IconData icon;

  /// The title of the setting.
  final String title;

  /// The subtitle/description of the setting (optional).
  final String? subtitle;

  /// The current switch value.
  final bool value;

  /// The callback when the switch value changes.
  final void Function(bool)? onChanged;

  /// Whether this tile is enabled (can be toggled).
  final bool enabled;

  const SettingsTileWithSwitch({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.value,
    this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? () => onChanged?.call(!value) : null,
        splashColor: theme.primaryColor.withOpacity(0.1),
        highlightColor: theme.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(UIConstants.defaultRadius),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: UIConstants.settingsTileHorizontalPadding,
            vertical: UIConstants.settingsTileVerticalPadding,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Leading icon
              SizedBox(
                width: 40,
                height: 40,
                child: Icon(
                  icon,
                  size: UIConstants.settingsTileIconSize,
                  color: enabled
                      ? theme.colorScheme.primary
                      : theme.disabledColor,
                ),
              ),

              const SizedBox(width: Spacing.md),

              // Title and subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: AppTypography.bodyLarge.copyWith(
                        color: enabled
                            ? theme.colorScheme.onSurface
                            : theme.disabledColor,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: AppTypography.labelSmall.copyWith(
                          color: enabled
                              ? theme.colorScheme.onSurface.withOpacity(0.6)
                              : theme.disabledColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Switch
              Switch(
                value: value,
                onChanged: enabled ? onChanged : null,
                activeThumbColor: theme.colorScheme.primary,
                inactiveThumbColor: isDark
                    ? theme.colorScheme.outline
                    : theme.colorScheme.outline,
                inactiveTrackColor: isDark
                    ? theme.colorScheme.outline.withOpacity(0.3)
                    : theme.colorScheme.outline.withOpacity(0.3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
