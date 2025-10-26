import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/fonts.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
import 'package:my_flutter_app/features/settings/presentation/models/settings_item_model.dart';
import 'package:my_flutter_app/features/settings/presentation/widgets/settings_section.dart';
import 'package:my_flutter_app/features/settings/presentation/widgets/settings_tile.dart';
import 'package:my_flutter_app/features/settings/presentation/widgets/settings_tile_with_switch.dart';
import 'package:my_flutter_app/features/settings/presentation/widgets/settings_tile_with_value.dart';

/// A widget that displays a list of settings sections.
class SettingsList extends StatelessWidget {
  /// The list of settings sections to display.
  final List<SettingsSectionModel> sections;

  const SettingsList({super.key, required this.sections});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sections.asMap().entries.expand((entry) {
        final index = entry.key;
        final section = entry.value;
        return [
          // Section title
          if (index > 0) const SizedBox(height: UIConstants.largePadding),
          Padding(
            padding: const EdgeInsets.only(
              left: UIConstants.settingsCardContentLeftPadding,
              bottom: UIConstants.smallPadding,
            ),
            child: Text(
              section.title,
              style: AppTypography.labelMedium.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          // Card-wrapped section
          SettingsSection(
            showTopDivider: false,
            showBottomDivider: false,
            children: section.items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isLast = index == section.items.length - 1;

              return Column(
                children: [
                  item.isSwitch
                      ? SettingsTileWithSwitch(
                          icon: item.icon,
                          title: item.title,
                          subtitle: item.subtitle,
                          value: item.switchValue ?? false,
                          onChanged: item.enabled ? item.onSwitchChanged : null,
                          enabled: item.enabled,
                        )
                      : item.value != null
                      ? SettingsTileWithValue(
                          icon: item.icon,
                          title: item.title,
                          value: item.value!,
                          onTap: item.onTap,
                          enabled: item.enabled,
                        )
                      : SettingsTile(
                          icon: item.icon,
                          title: item.title,
                          onTap: item.onTap,
                          enabled: item.enabled,
                        ),
                  if (!isLast)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: UIConstants.smallPadding,
                        vertical: UIConstants.extraSmallPadding,
                      ),
                      child: Divider(
                        height: UIConstants.settingsSectionDividerHeight,
                        thickness: UIConstants.settingsSectionDividerHeight,
                        color: theme.colorScheme.outline.withOpacity(0.4),
                      ),
                    ),
                ],
              );
            }).toList(),
          ),
        ];
      }).toList(),
    );
  }
}
