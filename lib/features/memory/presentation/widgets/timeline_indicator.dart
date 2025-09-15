import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/spacings.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';

class TimelineIndicator extends StatelessWidget {
  final bool isFirst;
  final bool isLast;

  const TimelineIndicator({
    required this.isFirst,
    required this.isLast,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final lineColor = Theme.of(context).colorScheme.onSurface.withOpacity(0.5);
    return Column(
      children: <Widget>[
        // Top half of the line segment (before the dot)
        if (!isFirst)
          Expanded(
            child: Container(
              width: UIConstants.timelineLineWidth,
              color: lineColor,
            ),
          )
        else
          const SizedBox(
            height: Spacing.sm,
          ), // Half the dot height to align its center for the first item
        Container(
          width: UIConstants.timelineDotSize,
          height: UIConstants.timelineDotSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.primary,
            border: Border.all(
              color: lineColor,
              width: UIConstants.timelineLineBorderWidth,
            ),
          ),
        ),
        // Bottom half of the line segment (after the dot)
        if (!isLast)
          Expanded(
            child: Container(
              width: UIConstants.timelineLineWidth,
              color: lineColor,
            ),
          )
        else
          const SizedBox(
            height: Spacing.sm,
          ), // Half the dot height to align its center for the last item
      ],
    );
  }
}
