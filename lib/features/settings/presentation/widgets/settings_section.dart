import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/fonts.dart';
import 'package:my_flutter_app/core/theme/spacings.dart';

/// A reusable widget for displaying a section of settings with a title and children.
class SettingsSection extends StatelessWidget {
  /// The title of the settings section.
  final String title;

  /// The list of widgets to display in this section.
  final List<Widget> children;

  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: Spacing.sm),
        ...children,
      ],
    );
  }
}
