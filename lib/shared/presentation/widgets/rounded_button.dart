import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';

/// A rounded button widget with large border radius (pill-shaped)
/// Height is smaller than default buttons for a more compact appearance
class RoundedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final bool enabled;

  const RoundedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.height,
    this.padding,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveHeight = height ?? UIConstants.smallButtonHeight;
    final effectiveBackgroundColor =
        backgroundColor ?? Theme.of(context).colorScheme.primary;
    final effectiveForegroundColor =
        foregroundColor ?? Theme.of(context).colorScheme.onPrimary;
    final effectivePadding =
        padding ??
        const EdgeInsets.symmetric(
          horizontal: UIConstants.defaultPadding,
          vertical: UIConstants.smallPadding,
        );

    // Use half of height as border radius for pill shape
    final borderRadius = BorderRadius.circular(effectiveHeight / 2);

    return SizedBox(
      height: effectiveHeight,
      child: TextButton(
        onPressed: enabled ? onPressed : null,
        style: TextButton.styleFrom(
          backgroundColor: enabled
              ? effectiveBackgroundColor
              : effectiveBackgroundColor.withValues(alpha: 0.5),
          foregroundColor: effectiveForegroundColor,
          padding: effectivePadding,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          elevation: 0,
        ),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
