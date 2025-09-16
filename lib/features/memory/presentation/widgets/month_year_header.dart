import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/fonts.dart';
import 'package:my_flutter_app/core/theme/spacings.dart';

/// Displays a collapsible month and year header for grouped memories
class MonthYearHeader extends StatelessWidget {
  final String monthYear;
  final bool isExpanded;
  final VoidCallback onTap;

  const MonthYearHeader({
    super.key,
    required this.monthYear,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: Spacing.lg,
          horizontal: 0,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                monthYear,
                style: AppTypography.labelLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            AnimatedRotation(
              turns: isExpanded ? 0.0 : 0.5,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                Icons.keyboard_arrow_down,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
