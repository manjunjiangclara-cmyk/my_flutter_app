import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
import 'package:my_flutter_app/shared/presentation/widgets/bottom_sheet_header.dart';

/// A reusable base bottom sheet widget that provides consistent styling
/// across the app for all bottom sheet implementations.
class BaseBottomSheet extends StatelessWidget {
  /// The title to display at the top of the bottom sheet (optional)
  final String? title;

  /// The main content of the bottom sheet
  final Widget child;

  /// Whether to show the handle bar at the top (legacy, use header instead)
  final bool showHandle;

  /// Custom height for the bottom sheet (optional, defaults to content-based)
  final double? height;

  /// Whether the bottom sheet should be scrollable
  final bool isScrollable;

  /// Padding around the content
  final EdgeInsetsGeometry? contentPadding;

  /// Close button callback (uses new header style when provided)
  final VoidCallback? onClose;

  /// Right action text (uses new header style when provided)
  final String? rightActionText;

  /// Right action callback (uses new header style when provided)
  final VoidCallback? onRightAction;

  /// Close button icon size
  final double? closeButtonIconSize;

  const BaseBottomSheet({
    super.key,
    this.title,
    required this.child,
    this.showHandle = false,
    this.height,
    this.isScrollable = false,
    this.contentPadding,
    this.onClose,
    this.rightActionText,
    this.onRightAction,
    this.closeButtonIconSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final useNewHeader =
        title != null && (onClose != null || rightActionText != null);

    Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // New header style with centered title and action buttons
        if (useNewHeader) ...[
          BottomSheetHeader(
            title: title!,
            onClose: onClose,
            rightActionText: rightActionText,
            onRightAction: onRightAction,
            closeButtonIconSize: closeButtonIconSize,
          ),
          SizedBox(height: UIConstants.defaultPadding),
        ] else if (showHandle) ...[
          // Legacy handle bar
          const SizedBox(height: UIConstants.smallPadding),
          Container(
            width: UIConstants.bottomSheetHandleWidth,
            height: UIConstants.bottomSheetHandleHeight,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withOpacity(0.2),
              borderRadius: BorderRadius.circular(
                UIConstants.bottomSheetHandleRadius,
              ),
            ),
          ),
          const SizedBox(height: UIConstants.mediumPadding),
        ] else if (title != null) ...[
          // Legacy title style
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: UIConstants.defaultPadding,
            ),
            child: Text(
              title!,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: UIConstants.defaultPadding),
        ],

        // Content
        Flexible(
          child: Padding(
            padding: contentPadding ?? EdgeInsets.zero,
            child: child,
          ),
        ),

        // Bottom padding above safe area
        SizedBox(height: UIConstants.defaultPadding),
      ],
    );

    // Wrap in scrollable if needed
    if (isScrollable) {
      content = SingleChildScrollView(child: content);
    }

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(UIConstants.bottomSheetRadius),
        ),
      ),
      padding: const EdgeInsets.only(
        left: UIConstants.defaultPadding,
        right: UIConstants.defaultPadding,
        top: UIConstants.defaultPadding,
        bottom: UIConstants.defaultPadding,
      ),
      child: SafeArea(
        top: false,
        child: height != null
            ? SizedBox(height: height, child: content)
            : content,
      ),
    );
  }

  /// Show the bottom sheet with consistent styling
  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    required Widget child,
    bool showHandle = false,
    double? height,
    bool isScrollable = false,
    EdgeInsetsGeometry? contentPadding,
    bool isDismissible = true,
    bool enableDrag = true,
    VoidCallback? onClose,
    String? rightActionText,
    VoidCallback? onRightAction,
    double? closeButtonIconSize,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      builder: (context) => BaseBottomSheet(
        title: title,
        showHandle: showHandle,
        height: height,
        isScrollable: isScrollable,
        contentPadding: contentPadding,
        onClose: onClose,
        rightActionText: rightActionText,
        onRightAction: onRightAction,
        closeButtonIconSize: closeButtonIconSize,
        child: child,
      ),
    );
  }
}
