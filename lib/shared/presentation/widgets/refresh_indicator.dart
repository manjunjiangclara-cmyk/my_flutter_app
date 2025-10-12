import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';

/// A reusable app-wide RefreshIndicator with consistent defaults.
class AppRefreshIndicator extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final Widget child;
  final double? displacement;
  final double? edgeOffset;
  final double? strokeWidth;
  final Color? color;
  final Color? backgroundColor;
  final ScrollNotificationPredicate? notificationPredicate;

  const AppRefreshIndicator({
    super.key,
    required this.onRefresh,
    required this.child,
    this.displacement,
    this.edgeOffset,
    this.strokeWidth,
    this.color,
    this.backgroundColor,
    this.notificationPredicate,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      displacement: displacement ?? UIConstants.refreshDisplacement,
      edgeOffset: edgeOffset ?? UIConstants.refreshEdgeOffset,
      strokeWidth: strokeWidth ?? UIConstants.refreshStrokeWidth,
      color: color ?? Theme.of(context).colorScheme.primary,
      backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.surface,
      notificationPredicate:
          notificationPredicate ?? defaultScrollNotificationPredicate,
      child: child,
    );
  }
}
