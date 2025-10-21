import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';

/// Style variants for ActionButton
enum ActionButtonStyle {
  icon, // Simple icon button (for AppBar actions)
  filled, // Filled button with background (for compose actions)
  circular, // Circular button with custom background color
}

/// A common action button widget for consistent styling across the app
class ActionButton extends StatelessWidget {
  final IconData? icon;
  final String? svgAssetPath;
  final VoidCallback? onPressed;
  final String? tooltip;
  final double? iconSize;
  final EdgeInsets? padding;
  final Color? iconColor;
  final Color? circularBackgroundColor; // only for circular style
  final BoxBorder? circularBorder; // only for circular style
  final bool enabled;
  final ActionButtonStyle style;

  const ActionButton({
    super.key,
    this.icon,
    this.svgAssetPath,
    this.onPressed,
    this.tooltip,
    this.iconSize,
    this.padding,
    this.iconColor,
    this.circularBackgroundColor,
    this.circularBorder,
    this.enabled = true,
    this.style = ActionButtonStyle.icon,
  }) : assert(
         icon != null || svgAssetPath != null,
         'Either icon or svgAssetPath must be provided',
       );

  /// Creates an outlined action button with consistent styling
  const ActionButton.outlined({
    super.key,
    this.icon,
    this.svgAssetPath,
    this.onPressed,
    this.tooltip,
    this.iconSize,
    this.padding,
    this.iconColor,
    this.circularBackgroundColor,
    this.circularBorder,
    this.enabled = true,
  }) : style = ActionButtonStyle.icon,
       assert(
         icon != null || svgAssetPath != null,
         'Either icon or svgAssetPath must be provided',
       );

  /// Creates a filled action button with background styling
  const ActionButton.filled({
    super.key,
    this.icon,
    this.svgAssetPath,
    this.onPressed,
    this.tooltip,
    this.iconSize,
    this.padding,
    this.iconColor,
    this.circularBackgroundColor,
    this.circularBorder,
    this.enabled = true,
  }) : style = ActionButtonStyle.filled,
       assert(
         icon != null || svgAssetPath != null,
         'Either icon or svgAssetPath must be provided',
       );

  /// Creates a circular action button with custom background color
  const ActionButton.circular({
    super.key,
    this.icon,
    this.svgAssetPath,
    this.onPressed,
    this.tooltip,
    this.iconSize,
    this.padding,
    this.iconColor,
    this.circularBackgroundColor,
    this.circularBorder,
    this.enabled = true,
  }) : style = ActionButtonStyle.circular,
       assert(
         icon != null || svgAssetPath != null,
         'Either icon or svgAssetPath must be provided',
       );

  @override
  Widget build(BuildContext context) {
    final effectiveIconSize =
        iconSize ??
        (style == ActionButtonStyle.filled
            ? UIConstants.actionButtonIconSize
            : style == ActionButtonStyle.circular
            ? UIConstants.defaultIconSize
            : UIConstants.defaultIconSize);

    final effectivePadding =
        padding ??
        (style == ActionButtonStyle.filled
            ? const EdgeInsets.all(UIConstants.actionButtonPadding)
            : style == ActionButtonStyle.circular
            ? const EdgeInsets.all(UIConstants.smallPadding)
            : const EdgeInsets.symmetric(
                horizontal: UIConstants.journalAppBarIconPadding,
              ));

    final effectiveIconColor =
        iconColor ??
        (enabled
            ? null
            : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38));

    // Create the appropriate icon widget
    Widget iconWidget;
    if (svgAssetPath != null) {
      iconWidget = SvgPicture.asset(
        svgAssetPath!,
        width: effectiveIconSize,
        height: effectiveIconSize,
        colorFilter: effectiveIconColor != null
            ? ColorFilter.mode(effectiveIconColor, BlendMode.srcIn)
            : null,
      );
    } else {
      iconWidget = Icon(
        icon!,
        size: effectiveIconSize,
        color: effectiveIconColor,
      );
    }

    switch (style) {
      case ActionButtonStyle.icon:
        return Padding(
          padding: effectivePadding,
          child: IconButton(
            icon: iconWidget,
            onPressed: enabled ? onPressed : null,
            tooltip: tooltip,
          ),
        );

      case ActionButtonStyle.filled:
        return GestureDetector(
          onTap: enabled ? onPressed : null,
          child: Container(
            padding: effectivePadding,
            decoration: BoxDecoration(
              color: enabled
                  ? Theme.of(context).colorScheme.outline.withValues(
                      alpha: UIConstants.dialogOpacity,
                    )
                  : Theme.of(context).colorScheme.outline.withValues(
                      alpha: UIConstants.dialogOpacity * 0.5,
                    ),
              borderRadius: BorderRadius.circular(UIConstants.largeRadius),
            ),
            child: iconWidget,
          ),
        );

      case ActionButtonStyle.circular:
        return GestureDetector(
          onTap: enabled ? onPressed : null,
          child: Container(
            padding: effectivePadding,
            decoration: BoxDecoration(
              color:
                  circularBackgroundColor ??
                  (enabled
                      ? Color.lerp(
                          Colors.grey[100]!,
                          Theme.of(context).colorScheme.surface,
                          0.3,
                        )
                      : Color.lerp(
                          Colors.grey[100]!,
                          Theme.of(context).colorScheme.surface,
                          0.3,
                        )!.withValues(alpha: 0.5)),
              shape: BoxShape.circle,
              border: circularBorder,
            ),
            child: iconWidget,
          ),
        );
    }
  }
}
