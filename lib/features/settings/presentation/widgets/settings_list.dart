import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/spacings.dart';
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
      children: sections.asMap().entries.map((entry) {
        final section = entry.value;

        return Column(
          children: [
            SettingsSection(
              title: section.title,
              children: section.items
                  .map(
                    (item) => SettingsTile(
                      icon: item.icon,
                      title: item.title,
                      subtitle: item.subtitle,
                      onTap: item.onTap,
                      enabled: item.enabled,
                    ),
                  )
                  .toList(),
            ),
            if (entry.key < sections.length - 1) SizedBox(height: Spacing.lg),
          ],
        );
      }).toList(),
    );
  }
}
