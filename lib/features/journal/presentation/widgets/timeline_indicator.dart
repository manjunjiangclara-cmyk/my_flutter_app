import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/spacings.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';

class TimelineIndicator extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final Color dotColor;
  final Color lineColor;

  const TimelineIndicator({
    required this.isFirst,
    required this.isLast,
    required this.dotColor,
    this.lineColor = Colors.grey,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(
          height: Spacing.sm,
        ), // Top padding for the card's vertical margin
        // Top half of the line segment (before the dot)
        if (!isFirst)
          Expanded(child: Container(width: 2, color: lineColor))
        else
          const SizedBox(
            height: Spacing.sm,
          ), // Half the dot height to align its center for the first item
        Container(
          width: UIConstants.smallIconSize,
          height: UIConstants.smallIconSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: dotColor,
            border: Border.all(color: Colors.white, width: 2),
          ),
        ),
        // Bottom half of the line segment (after the dot)
        if (!isLast)
          Expanded(child: Container(width: 2, color: lineColor))
        else
          const SizedBox(
            height: Spacing.sm,
          ), // Half the dot height to align its center for the last item
        const SizedBox(
          height: Spacing.sm,
        ), // Bottom padding for the card's vertical margin
      ],
    );
  }
}
