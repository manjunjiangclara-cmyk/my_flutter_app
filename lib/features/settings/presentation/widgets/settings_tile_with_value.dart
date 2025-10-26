import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/fonts.dart';
import 'package:my_flutter_app/core/theme/spacings.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';

/// A reusable widget for displaying settings items with a value and light dropdown arrow.
class SettingsTileWithValue extends StatelessWidget {
  /// The icon to display for this setting.
  final IconData icon;

  /// The title of the setting.
  final String title;

  /// The current value to display on the right side.
  final String value;

  /// The callback to execute when the tile is tapped.
  final void Function(BuildContext)? onTap;

  /// Whether this tile is enabled (can be tapped).
  final bool enabled;

  const SettingsTileWithValue({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? () => onTap?.call(context) : null,
        splashColor: theme.primaryColor.withOpacity(0.1),
        highlightColor: theme.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(UIConstants.defaultRadius),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: UIConstants.settingsTileHorizontalPadding,
            vertical: UIConstants.settingsTileVerticalPadding,
          ),
          child: Row(
            children: [
              // Leading icon
              SizedBox(
                width: UIConstants.settingsTileIconContainerSize,
                height: UIConstants.settingsTileIconContainerSize,
                child: Icon(
                  icon,
                  size: UIConstants.settingsTileIconSize,
                  color: enabled
                      ? theme.colorScheme.primary
                      : theme.disabledColor,
                ),
              ),

              const SizedBox(width: Spacing.md),

              // Title
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.bodyLarge.copyWith(
                    color: enabled
                        ? theme.colorScheme.onSurface
                        : theme.disabledColor,
                  ),
                ),
              ),

              // Value with light dropdown arrow
              if (enabled)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      value,
                      style: AppTypography.bodyLarge.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(width: Spacing.xs),
                    Transform.rotate(
                      angle: UIConstants.lightDropdownArrowRotation,
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        size: UIConstants.lightDropdownArrowSize,
                        color: theme.colorScheme.onSurface.withOpacity(
                          UIConstants.lightDropdownArrowOpacity,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
