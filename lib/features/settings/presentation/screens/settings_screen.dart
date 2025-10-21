import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/theme_provider.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
import 'package:my_flutter_app/features/settings/presentation/constants/settings_constants.dart';
import 'package:my_flutter_app/features/settings/presentation/widgets/settings_app_bar.dart';
import 'package:my_flutter_app/features/settings/presentation/widgets/settings_list.dart';
import 'package:provider/provider.dart';

/// The main settings screen that displays all app settings in a modular way.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SettingsAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(UIConstants.defaultPadding),
        child: Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return SettingsList(
              sections: SettingsConstants.getSettingsSections(context),
            );
          },
        ),
      ),
    );
  }
}
