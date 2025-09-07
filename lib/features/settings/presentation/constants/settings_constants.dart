import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/strings.dart';
import 'package:my_flutter_app/features/settings/presentation/models/settings_item_model.dart';

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
          icon: Icons.palette,
          title: AppStrings.theme,
          subtitle: AppStrings.changeAppAppearance,
          onTap: () {
            // Handle theme settings
          },
        ),
        SettingsItemModel(
          icon: Icons.notifications,
          title: AppStrings.notifications,
          subtitle: AppStrings.manageNotificationPreferences,
          onTap: () {
            // Handle notification settings
          },
        ),
      ],
    ),
    SettingsSectionModel(
      title: AppStrings.dataAndPrivacy,
      items: [
        SettingsItemModel(
          icon: Icons.backup,
          title: AppStrings.backupAndSync,
          subtitle: AppStrings.manageYourDataBackup,
          onTap: () {
            // Handle backup settings
          },
        ),
        SettingsItemModel(
          icon: Icons.security,
          title: AppStrings.privacy,
          subtitle: AppStrings.controlYourPrivacySettings,
          onTap: () {
            // Handle privacy settings
          },
        ),
      ],
    ),
    SettingsSectionModel(
      title: 'About',
      items: [
        SettingsItemModel(
          icon: Icons.info,
          title: AppStrings.appVersion,
          subtitle: appVersion,
          enabled: false, // Version info is not clickable
        ),
        SettingsItemModel(
          icon: Icons.help,
          title: AppStrings.helpAndSupport,
          subtitle: 'Get help and contact support',
          onTap: () {
            // Handle help
          },
        ),
      ],
    ),
  ];
}
