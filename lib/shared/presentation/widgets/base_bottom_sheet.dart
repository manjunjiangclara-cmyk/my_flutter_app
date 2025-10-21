import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';

/// A reusable base bottom sheet widget that provides consistent styling
/// across the app for all bottom sheet implementations.
class BaseBottomSheet extends StatelessWidget {
  /// The title to display at the top of the bottom sheet (optional)
  final String? title;

  /// The main content of the bottom sheet
  final Widget child;

  /// Whether to show the handle bar at the top
  final bool showHandle;

  /// Custom height for the bottom sheet (optional, defaults to content-based)
  final double? height;

  /// Whether the bottom sheet should be scrollable
  final bool isScrollable;

  /// Padding around the content
  final EdgeInsetsGeometry? contentPadding;

  const BaseBottomSheet({
    super.key,
    this.title,
    required this.child,
    this.showHandle = true,
    this.height,
    this.isScrollable = false,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Handle bar
        if (showHandle) ...[
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
        ],

        // Title
        if (title != null) ...[
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
          const SizedBox(height: UIConstants.defaultPadding),
        ],

        // Content
        Flexible(
          child: Padding(
            padding:
                contentPadding ??
                const EdgeInsets.symmetric(
                  horizontal: UIConstants.defaultPadding,
                ),
            child: child,
          ),
        ),

        // Bottom padding for safe area
        const SizedBox(height: UIConstants.defaultPadding),
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
          top: Radius.circular(UIConstants.extraLargeRadius),
        ),
      ),
      child: height != null
          ? SizedBox(height: height, child: content)
          : content,
    );
  }

  /// Show the bottom sheet with consistent styling
  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    required Widget child,
    bool showHandle = true,
    double? height,
    bool isScrollable = false,
    EdgeInsetsGeometry? contentPadding,
    bool isDismissible = true,
    bool enableDrag = true,
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
        child: child,
      ),
    );
  }
}
