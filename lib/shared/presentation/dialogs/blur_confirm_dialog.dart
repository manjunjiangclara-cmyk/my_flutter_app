import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/strings.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';

/// Shows a custom confirmation dialog with a blurred backdrop.
/// Returns true if confirmed, false if cancelled, null if dismissed.
Future<bool?> showBlurConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  String confirmText = AppStrings.delete,
  String cancelText = AppStrings.cancel,
}) {
  return showGeneralDialog<bool>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'blur_confirm_dialog',
    barrierColor: Colors.black.withOpacity(UIConstants.dialogBarrierOpacity),
    transitionDuration: UIConstants.dialogAnimationDuration,
    pageBuilder: (context, animation, secondaryAnimation) {
      return SafeArea(
        child: Stack(
          children: [
            // Blurred backdrop
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: UIConstants.dialogBackdropBlurSigma,
                  sigmaY: UIConstants.dialogBackdropBlurSigma,
                ),
                child: const SizedBox.shrink(),
              ),
            ),
            // Centered dialog card
            Center(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  margin: const EdgeInsets.all(UIConstants.defaultPadding),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(
                      UIConstants.defaultRadius,
                    ),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline.withOpacity(
                        UIConstants.dialogOpacity,
                      ),
                      width: UIConstants.dialogBorderWidth,
                    ),
                    boxShadow: kElevationToShadow[2],
                  ),
                  padding: const EdgeInsets.all(UIConstants.defaultPadding),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: UIConstants.smallPadding),
                      Text(
                        message,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: UIConstants.mediumPadding),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text(cancelText),
                          ),
                          const SizedBox(width: UIConstants.smallPadding),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            style: TextButton.styleFrom(
                              foregroundColor: Theme.of(
                                context,
                              ).colorScheme.error,
                            ),
                            child: Text(confirmText),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.98, end: 1.0).animate(curved),
          child: child,
        ),
      );
    },
  );
}
