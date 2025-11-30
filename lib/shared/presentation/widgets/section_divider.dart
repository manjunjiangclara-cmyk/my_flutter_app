import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';

/// A reusable horizontal divider widget with consistent styling.
/// Used in settings sections, location picker, and other list items.
class SectionDivider extends StatelessWidget {
  final EdgeInsets? padding;
  final double? height;
  final double? thickness;
  final Color? color;
  final double opacity;

  const SectionDivider({
    super.key,
    this.padding,
    this.height,
    this.thickness,
    this.color,
    this.opacity = 0.4,
  });

  @override
  Widget build(BuildContext context) {
    final effectivePadding =
        padding ??
        const EdgeInsets.symmetric(
          horizontal: UIConstants.smallPadding,
          vertical: UIConstants.extraSmallPadding,
        );
    final effectiveHeight = height ?? UIConstants.settingsSectionDividerHeight;
    final effectiveThickness =
        thickness ?? UIConstants.settingsSectionDividerHeight;
    final effectiveColor =
        color ?? Theme.of(context).colorScheme.outline.withOpacity(opacity);

    return Padding(
      padding: effectivePadding,
      child: Divider(
        height: effectiveHeight,
        thickness: effectiveThickness,
        color: effectiveColor,
      ),
    );
  }
}
