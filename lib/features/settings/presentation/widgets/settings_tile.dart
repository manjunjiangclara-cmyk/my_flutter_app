import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/fonts.dart';
import 'package:my_flutter_app/core/theme/spacings.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';

/// A reusable widget for displaying individual settings items in Airbnb style.
class SettingsTile extends StatelessWidget {
  /// The icon to display for this setting.
  final IconData icon;

  /// The title of the setting.
  final String title;

  /// The callback to execute when the tile is tapped.
  final void Function(BuildContext)? onTap;

  /// Whether this tile is enabled (can be tapped).
  final bool enabled;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
                width: 40,
                height: 40,
                child: Icon(
                  icon,
                  size: UIConstants.settingsTileIconSize,
                  color: enabled ? theme.primaryColor : theme.disabledColor,
                ),
              ),

              const SizedBox(width: Spacing.md),

              // Title
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.bodyLarge.copyWith(
                    // fontWeight: FontWeight.w500,
                    // fontSize: 15,
                    color: enabled
                        ? theme.colorScheme.onSurface
                        : theme.disabledColor,
                  ),
                ),
              ),

              // Trailing chevron
              if (enabled)
                Icon(
                  Icons.chevron_right,
                  size: UIConstants.settingsTileTrailingIconSize,
                  color: theme.colorScheme.onSurface.withOpacity(0.4),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
