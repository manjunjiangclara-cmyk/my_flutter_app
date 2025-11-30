import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';

/// A circular close button widget with the same style as photo attachment close button
/// Uses a semi-transparent circular background with a close icon
class CircularCloseButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final double? iconSize;
  final EdgeInsets? padding;

  const CircularCloseButton({
    super.key,
    this.onPressed,
    this.iconSize,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveIconSize =
        iconSize ?? UIConstants.photoAttachmentCloseIconSize;
    final effectivePadding =
        padding ??
        const EdgeInsets.all(UIConstants.photoAttachmentCloseButtonPadding);

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: effectivePadding,
        decoration: BoxDecoration(
          color: Theme.of(
            context,
          ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.8),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.close,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          size: effectiveIconSize,
        ),
      ),
    );
  }
}
