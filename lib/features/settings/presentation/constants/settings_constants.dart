import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/services/biometric_auth_provider.dart';
import 'package:my_flutter_app/core/services/splash_settings_provider.dart';
import 'package:my_flutter_app/core/strings.dart';
import 'package:my_flutter_app/core/theme/theme_provider.dart';
import 'package:my_flutter_app/features/settings/presentation/models/settings_item_model.dart';
import 'package:my_flutter_app/features/settings/presentation/widgets/theme_bottom_sheet.dart';
import 'package:provider/provider.dart';

/// Constants and configuration for the settings screen.
class SettingsConstants {
  SettingsConstants._();

  /// The current app version.
  static const String appVersion = '1.0.0';

  /// Get the display value for the current theme mode
  static String getThemeDisplayValue(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    switch (themeProvider.themeMode) {
      case ThemeMode.light:
        return AppStrings.themeValueLight;
      case ThemeMode.dark:
        return AppStrings.themeValueDark;
      case ThemeMode.system:
        return AppStrings.themeValueSystem;
    }
  }

  /// All settings sections with their items.
  static List<SettingsSectionModel> getSettingsSections(
    BuildContext context,
  ) => [
    SettingsSectionModel(
      title: AppStrings.general,
      items: [
        SettingsItemModel(
          icon: Icons.palette_outlined,
          title: AppStrings.theme,
          value: getThemeDisplayValue(context),
          onTap: (context) {
            ThemeBottomSheet.show(context);
          },
        ),
        SettingsItemModel(
          icon: Icons.format_quote_outlined,
          title: AppStrings.showSplashQuote,
          subtitle: AppStrings.showSplashQuoteSubtitle,
          isSwitch: true,
          switchValue: context.watch<SplashSettingsProvider>().showQuote,
          onSwitchChanged: (value) {
            context.read<SplashSettingsProvider>().setShowQuote(value);
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
        // Biometric toggle
        SettingsItemModel(
          icon: Icons.face_retouching_natural_outlined,
          title: AppStrings.requireBiometricOnLaunch,
          subtitle: AppStrings.biometricDescription,
          isSwitch: true,
          switchValue: context.watch<BiometricAuthProvider>().requireOnLaunch,
          onSwitchChanged: (value) {
            context.read<BiometricAuthProvider>().setRequireOnLaunch(value);
          },
        ),
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
