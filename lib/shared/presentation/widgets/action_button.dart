import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';

/// Style variants for ActionButton
enum ActionButtonStyle {
  icon, // Simple icon button (for AppBar actions)
  filled, // Filled button with background (for compose actions)
}

/// A common action button widget for consistent styling across the app
class ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final double? iconSize;
  final EdgeInsets? padding;
  final Color? iconColor;
  final bool enabled;
  final ActionButtonStyle style;

  const ActionButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.iconSize,
    this.padding,
    this.iconColor,
    this.enabled = true,
    this.style = ActionButtonStyle.icon,
  });

  /// Creates an outlined action button with consistent styling
  const ActionButton.outlined({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.iconSize,
    this.padding,
    this.iconColor,
    this.enabled = true,
  }) : style = ActionButtonStyle.icon;

  /// Creates a filled action button with background styling
  const ActionButton.filled({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.iconSize,
    this.padding,
    this.iconColor,
    this.enabled = true,
  }) : style = ActionButtonStyle.filled;

  @override
  Widget build(BuildContext context) {
    final effectiveIconSize =
        iconSize ??
        (style == ActionButtonStyle.filled
            ? UIConstants.actionButtonIconSize
            : UIConstants.defaultIconSize);

    final effectivePadding =
        padding ??
        (style == ActionButtonStyle.filled
            ? const EdgeInsets.all(UIConstants.actionButtonPadding)
            : const EdgeInsets.symmetric(
                horizontal: UIConstants.journalAppBarIconPadding,
              ));

    final effectiveIconColor =
        iconColor ??
        (enabled
            ? null
            : Theme.of(context).colorScheme.onSurface.withOpacity(0.38));

    switch (style) {
      case ActionButtonStyle.icon:
        return Padding(
          padding: effectivePadding,
          child: IconButton(
            icon: Icon(
              icon,
              size: effectiveIconSize,
              color: effectiveIconColor,
            ),
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
              borderRadius: BorderRadius.circular(UIConstants.defaultRadius),
            ),
            child: Icon(
              icon,
              size: effectiveIconSize,
              color: effectiveIconColor,
            ),
          ),
        );
    }
  }
}
