import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';

/// A reusable widget for displaying a section of settings with a horizontal divider.
class SettingsSection extends StatelessWidget {
  /// The list of widgets to display in this section.
  final List<Widget> children;

  /// Whether to show the top divider (default: true).
  final bool showTopDivider;

  /// Whether to show the bottom divider (default: false).
  final bool showBottomDivider;

  const SettingsSection({
    super.key,
    required this.children,
    this.showTopDivider = false,
    this.showBottomDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: theme.colorScheme.primaryContainer,
      elevation: UIConstants.smallElevation,
      shadowColor: theme.colorScheme.shadow.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UIConstants.largeRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: UIConstants.settingsCardContentLeftPadding,
          right: UIConstants.defaultCardPadding,
          top: UIConstants.defaultCardPadding,
          bottom: UIConstants.defaultCardPadding,
        ),
        child: Column(children: [...children]),
      ),
    );
  }
}
