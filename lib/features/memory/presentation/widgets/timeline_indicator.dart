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
    final colorScheme = Theme.of(context).colorScheme;
    final bool isLight = colorScheme.brightness == Brightness.light;
    final Color baseLine = colorScheme.outline;
    final Color lineColor = isLight
        ? baseLine.withOpacity(UIConstants.timelineLineOpacityLight)
        : baseLine.withOpacity(UIConstants.timelineLineOpacityDark);
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
            color: isLight
                ? Color.lerp(
                    colorScheme.primary,
                    colorScheme.surface,
                    UIConstants.timelineDotFillBlendLight,
                  )!
                : Color.lerp(
                    colorScheme.primary,
                    colorScheme.surface,
                    UIConstants.timelineDotFillBlendDark,
                  )!,
            border: Border.all(
              color: baseLine,
              width: UIConstants.timelineLineBorderWidth,
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withOpacity(
                  isLight
                      ? UIConstants.timelineShadowOpacity
                      : UIConstants.timelineShadowOpacityDark,
                ),
                blurRadius: isLight
                    ? UIConstants.timelineShadowBlur
                    : UIConstants.timelineShadowBlurDark,
                offset: Offset(
                  0,
                  isLight
                      ? UIConstants.timelineShadowOffsetY
                      : UIConstants.timelineShadowOffsetYDark,
                ),
                spreadRadius: 0,
              ),
            ],
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
