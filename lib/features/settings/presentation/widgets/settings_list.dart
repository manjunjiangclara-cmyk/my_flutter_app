import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
import 'package:my_flutter_app/features/settings/presentation/models/settings_item_model.dart';
import 'package:my_flutter_app/features/settings/presentation/widgets/settings_section.dart';
import 'package:my_flutter_app/features/settings/presentation/widgets/settings_tile.dart';

/// A widget that displays a list of settings sections.
class SettingsList extends StatelessWidget {
  /// The list of settings sections to display.
  final List<SettingsSectionModel> sections;

  const SettingsList({super.key, required this.sections});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sections.asMap().entries.expand((entry) {
        final section = entry.value;
        return [
          // Card-wrapped section
          SettingsSection(
            showTopDivider: false,
            showBottomDivider: false,
            children: section.items
                .map(
                  (item) => SettingsTile(
                    icon: item.icon,
                    title: item.title,
                    onTap: item.onTap,
                    enabled: item.enabled,
                  ),
                )
                .toList(),
          ),
          // Spacing between cards
          const SizedBox(height: UIConstants.settingsCardSpacing),
        ];
      }).toList(),
    );
  }
}
