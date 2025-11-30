import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';

/// A reusable trailing chevron icon widget with consistent styling.
/// Used in settings tiles, location picker, and other list items.
class TrailingChevron extends StatelessWidget {
  final double? size;
  final Color? color;
  final double opacity;

  const TrailingChevron({super.key, this.size, this.color, this.opacity = 0.4});

  @override
  Widget build(BuildContext context) {
    final effectiveSize = size ?? UIConstants.settingsTileTrailingIconSize;
    final effectiveColor =
        color ?? Theme.of(context).colorScheme.onSurface.withOpacity(opacity);

    return Icon(
      Icons.chevron_right,
      size: effectiveSize,
      color: effectiveColor,
    );
  }
}
