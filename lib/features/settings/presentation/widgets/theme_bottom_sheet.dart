import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/strings.dart';
import 'package:my_flutter_app/core/theme/fonts.dart';
import 'package:my_flutter_app/core/theme/theme_provider.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
import 'package:my_flutter_app/shared/presentation/widgets/base_bottom_sheet.dart';
import 'package:provider/provider.dart';

/// Bottom sheet for selecting app theme
class ThemeBottomSheet extends StatelessWidget {
  const ThemeBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Column(
          children: [
            _buildThemeOption(
              context,
              title: AppStrings.systemTheme,
              icon: Icons.brightness_auto_outlined,
              isSelected: themeProvider.themeMode == ThemeMode.system,
              onTap: () {
                themeProvider.setThemeMode(ThemeMode.system);
                Navigator.of(context).pop();
              },
            ),
            _buildThemeOption(
              context,
              title: AppStrings.lightTheme,
              icon: Icons.light_mode_outlined,
              isSelected: themeProvider.themeMode == ThemeMode.light,
              onTap: () {
                themeProvider.setThemeMode(ThemeMode.light);
                Navigator.of(context).pop();
              },
            ),
            _buildThemeOption(
              context,
              title: AppStrings.darkTheme,
              icon: Icons.dark_mode_outlined,
              isSelected: themeProvider.themeMode == ThemeMode.dark,
              onTap: () {
                themeProvider.setThemeMode(ThemeMode.dark);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildThemeOption(
    BuildContext context, {
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(UIConstants.defaultRadius),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: UIConstants.defaultPadding,
          vertical: UIConstants.defaultPadding,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
              size: UIConstants.defaultIconSize,
            ),
            const SizedBox(width: UIConstants.defaultPadding),
            Expanded(
              child: Text(
                title,
                style: AppTypography.bodyLarge.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle_outlined,
                color: theme.colorScheme.primary,
                size: UIConstants.defaultIconSize,
              ),
          ],
        ),
      ),
    );
  }

  /// Show the theme selection bottom sheet
  static void show(BuildContext context) {
    BaseBottomSheet.show(
      context: context,
      title: AppStrings.selectTheme,
      height:
          MediaQuery.of(context).size.height *
          UIConstants.themeBottomSheetHeight,
      onClose: () => Navigator.of(context).pop(),
      closeButtonIconSize: UIConstants.datePickerCloseButtonIconSize,
      child: const ThemeBottomSheet(),
    );
  }
}
