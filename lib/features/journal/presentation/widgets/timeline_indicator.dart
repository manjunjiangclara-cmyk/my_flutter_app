import 'package:flutter/material.dart';

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
        const SizedBox(height: 8), // Top padding for the card's vertical margin
        // Top half of the line segment (before the dot)
        if (!isFirst)
          Expanded(child: Container(width: 2, color: lineColor))
        else
          const SizedBox(
            height: 8,
          ), // Half the dot height to align its center for the first item
        Container(
          width: 16,
          height: 16,
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
            height: 8,
          ), // Half the dot height to align its center for the last item
        const SizedBox(
          height: 8,
        ), // Bottom padding for the card's vertical margin
      ],
    );
  }
}
