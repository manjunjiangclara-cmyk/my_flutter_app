import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';

/// Fully circular icon button that preserves Material pressed/hover/focus states.
class RoundIconButton extends StatelessWidget {
  final IconData? icon;
  final String? svgAssetPath;
  final VoidCallback? onPressed;
  final String? tooltip;
  final double? diameter;
  final double? iconSize;
  final EdgeInsetsGeometry? padding;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderWidth;

  const RoundIconButton({
    super.key,
    this.icon,
    this.svgAssetPath,
    required this.onPressed,
    this.tooltip,
    this.diameter,
    this.iconSize,
    this.padding,
    this.foregroundColor,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
  }) : assert(
         icon != null || svgAssetPath != null,
         'Provide icon or svgAssetPath',
       );

  @override
  Widget build(BuildContext context) {
    final double effectiveDiameter =
        diameter ?? UIConstants.actionButtonDiameter;
    final double effectiveIconSize = iconSize ?? UIConstants.defaultIconSize;
    final EdgeInsetsGeometry effectivePadding =
        padding ?? const EdgeInsets.all(UIConstants.smallPadding);

    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Color effectiveForeground = foregroundColor ?? scheme.onSecondary;
    final Color effectiveBackground = backgroundColor ?? scheme.secondary;

    final Widget iconWidget = svgAssetPath != null
        ? SvgPicture.asset(
            svgAssetPath!,
            width: effectiveIconSize,
            height: effectiveIconSize,
            colorFilter: ColorFilter.mode(effectiveForeground, BlendMode.srcIn),
          )
        : Icon(icon!, size: effectiveIconSize, color: effectiveForeground);

    // Build the button with optional border
    final Widget buttonContent = IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      icon: Padding(padding: effectivePadding, child: iconWidget),
      style: IconButton.styleFrom(
        foregroundColor: effectiveForeground,
        backgroundColor: effectiveBackground,
        shape: const CircleBorder(),
        padding: EdgeInsets.zero,
        minimumSize: Size(effectiveDiameter, effectiveDiameter),
        fixedSize: Size(effectiveDiameter, effectiveDiameter),
      ),
      splashRadius: UIConstants.actionButtonSplashRadius,
    );

    // Apply border if specified
    if (borderWidth != null && borderWidth! > 0) {
      final Color effectiveBorderColor =
          borderColor ??
          scheme.outline.withValues(alpha: UIConstants.dialogOpacity);

      return Container(
        width: effectiveDiameter,
        height: effectiveDiameter,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: effectiveBorderColor, width: borderWidth!),
        ),
        child: ClipOval(
          child: Material(
            color: effectiveBackground,
            shape: const CircleBorder(),
            child: buttonContent,
          ),
        ),
      );
    }

    return SizedBox(
      width: effectiveDiameter,
      height: effectiveDiameter,
      child: Material(
        color: effectiveBackground,
        shape: const CircleBorder(),
        child: buttonContent,
      ),
    );
  }
}
