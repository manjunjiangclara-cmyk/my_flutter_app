import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/fonts.dart';
import 'package:my_flutter_app/core/theme/spacings.dart';

/// A reusable widget for displaying individual settings items.
class SettingsTile extends StatelessWidget {
  /// The icon to display for this setting.
  final IconData icon;

  /// The title of the setting.
  final String title;

  /// The subtitle/description of the setting.
  final String subtitle;

  /// The callback to execute when the tile is tapped.
  final VoidCallback? onTap;

  /// Whether this tile is enabled (can be tapped).
  final bool enabled;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: enabled ? null : Theme.of(context).disabledColor,
      ),
      title: Text(
        title,
        style: AppTypography.labelMedium.copyWith(
          color: enabled ? null : Theme.of(context).disabledColor,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTypography.labelSmall.copyWith(
          color: enabled ? null : Theme.of(context).disabledColor,
        ),
      ),
      onTap: enabled ? onTap : null,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: Spacing.lg,
        vertical: Spacing.xs,
      ),
      dense: true,
    );
  }
}
