import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_flutter_app/core/theme/fonts.dart';
import 'package:my_flutter_app/core/theme/spacings.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';

/// Displays a collapsible month and year header for grouped memories
class MonthYearHeader extends StatefulWidget {
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
  State<MonthYearHeader> createState() => _MonthYearHeaderState();
}

class _MonthYearHeaderState extends State<MonthYearHeader> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        HapticFeedback.lightImpact();
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedOpacity(
        opacity: _isPressed ? 0.6 : 1.0,
        duration: UIConstants.fastAnimation,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: Spacing.lg,
            horizontal: 0,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.monthYear,
                  style: AppTypography.labelLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              AnimatedRotation(
                turns: widget.isExpanded ? 0.0 : 0.5,
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
