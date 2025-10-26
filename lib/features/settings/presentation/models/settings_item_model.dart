import 'package:flutter/material.dart';

/// Represents a single settings item with its properties.
class SettingsItemModel {
  /// The icon to display for this setting.
  final IconData icon;

  /// The title of the setting.
  final String title;

  /// The subtitle/description of the setting (optional).
  final String? subtitle;

  /// The current value to display (optional, for items with values).
  final String? value;

  /// The callback to execute when the item is tapped.
  final void Function(BuildContext)? onTap;

  /// Whether this item is enabled (can be tapped).
  final bool enabled;

  /// Whether this item is a switch
  final bool isSwitch;

  /// Current switch value (only used when isSwitch == true)
  final bool? switchValue;

  /// Callback when switch value changes
  final void Function(bool)? onSwitchChanged;

  const SettingsItemModel({
    required this.icon,
    required this.title,
    this.subtitle,
    this.value,
    this.onTap,
    this.enabled = true,
    this.isSwitch = false,
    this.switchValue,
    this.onSwitchChanged,
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
