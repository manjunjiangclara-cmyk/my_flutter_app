import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/fonts.dart';
import 'package:my_flutter_app/shared/presentation/widgets/circular_close_button.dart';

/// A reusable bottom sheet header with centered title and action buttons on sides
class BottomSheetHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onClose;
  final String? rightActionText;
  final VoidCallback? onRightAction;
  final double? closeButtonIconSize;

  const BottomSheetHeader({
    super.key,
    required this.title,
    this.onClose,
    this.rightActionText,
    this.onRightAction,
    this.closeButtonIconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (onClose != null)
              CircularCloseButton(
                onPressed: onClose,
                iconSize: closeButtonIconSize,
              )
            else
              const SizedBox.shrink(),
            if (rightActionText != null && onRightAction != null)
              TextButton(
                onPressed: onRightAction,
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 8.0,
                  ),
                ),
                child: Text(
                  rightActionText!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            else
              const SizedBox.shrink(),
          ],
        ),
        Text(
          title,
          style: AppTypography.bodyLarge.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

