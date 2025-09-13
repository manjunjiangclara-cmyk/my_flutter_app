import 'package:flutter/material.dart';

/// Represents a single settings item with its properties.
class SettingsItemModel {
  /// The icon to display for this setting.
  final IconData icon;

  /// The title of the setting.
  final String title;

  /// The subtitle/description of the setting.
  final String subtitle;

  /// The callback to execute when the item is tapped.
  final void Function(BuildContext)? onTap;

  /// Whether this item is enabled (can be tapped).
  final bool enabled;

  const SettingsItemModel({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.enabled = true,
  });
}

/// Represents a section of settings with a title and list of items.
class SettingsSectionModel {
  /// The title of the settings section.
  final String title;

  /// The list of settings items in this section.
  final List<SettingsItemModel> items;

  const SettingsSectionModel({required this.title, required this.items});
}
