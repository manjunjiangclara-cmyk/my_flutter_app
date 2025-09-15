import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/fonts.dart';
import 'package:my_flutter_app/core/theme/spacings.dart';

/// Displays a month and year header for grouped memories
class MonthYearHeader extends StatelessWidget {
  final String monthYear;

  const MonthYearHeader({super.key, required this.monthYear});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.lg, horizontal: 0),
      child: Text(
        monthYear,
        style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
