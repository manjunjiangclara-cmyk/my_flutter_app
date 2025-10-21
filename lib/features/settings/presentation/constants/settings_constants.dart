import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/strings.dart';
import 'package:my_flutter_app/features/settings/presentation/models/settings_item_model.dart';
import 'package:my_flutter_app/features/settings/presentation/screens/theme_selection_screen.dart';

/// Constants and configuration for the settings screen.
class SettingsConstants {
  SettingsConstants._();

  /// The current app version.
  static const String appVersion = '1.0.0';

  /// All settings sections with their items.
  static List<SettingsSectionModel> get settingsSections => [
    SettingsSectionModel(
      title: AppStrings.general,
      items: [
        SettingsItemModel(
          icon: Icons.palette_outlined,
          title: AppStrings.theme,
          onTap: (context) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ThemeSelectionScreen(),
              ),
            );
          },
        ),
        SettingsItemModel(
          icon: Icons.notifications_outlined,
          title: AppStrings.notifications,
          onTap: (context) {
            // Handle notification settings
          },
        ),
      ],
    ),
    SettingsSectionModel(
      title: AppStrings.dataAndPrivacy,
      items: [
        SettingsItemModel(
          icon: Icons.backup_outlined,
          title: AppStrings.backupAndSync,
          onTap: (context) {
            // Handle backup settings
          },
        ),
        SettingsItemModel(
          icon: Icons.security_outlined,
          title: AppStrings.privacy,
          onTap: (context) {
            // Handle privacy settings
          },
        ),
      ],
    ),
    SettingsSectionModel(
      title: 'About',
      items: [
        SettingsItemModel(
          icon: Icons.info_outlined,
          title: AppStrings.appVersion,
          enabled: false, // Version info is not clickable
        ),
        SettingsItemModel(
          icon: Icons.help_outlined,
          title: AppStrings.helpAndSupport,
          onTap: (context) {
            // Handle help
          },
        ),
      ],
    ),
  ];
}
