import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';

class LiquidGlassView extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int>? onButtonTap;

  const LiquidGlassView({
    super.key,
    required this.selectedIndex,
    this.onButtonTap,
  });

  @override
  State<LiquidGlassView> createState() => _LiquidGlassViewState();
}

class _LiquidGlassViewState extends State<LiquidGlassView> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  @override
  void didUpdateWidget(LiquidGlassView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedIndex != oldWidget.selectedIndex) {
      _selectedIndex = widget.selectedIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bool isLight = colorScheme.brightness == Brightness.light;
    final Color baseLine = colorScheme.outline;
    final Color lineColor = isLight
        ? baseLine.withValues(alpha: UIConstants.timelineLineOpacityLight)
        : baseLine.withValues(alpha: UIConstants.timelineLineOpacityDark);

    return Container(
      width: 280,
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: Colors.white.withValues(alpha: 0.15),
        border: Border.all(color: lineColor, width: 0.8),
        boxShadow: [
          // Primary shadow for depth
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
          // Secondary shadow for more depth
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 24,
            offset: const Offset(0, 6),
          ),
          // Top highlight
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.06),
            blurRadius: 0,
            offset: const Offset(0, -0.5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              color: Colors.white.withValues(alpha: 0.1),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(child: _buildButton(Icons.chrome_reader_mode, 0)),
                  Expanded(child: _buildButton(Icons.edit, 1)),
                  Expanded(child: _buildButton(Icons.settings, 2)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(IconData icon, int index) {
    final isSelected = index == _selectedIndex;
    final colorScheme = Theme.of(context).colorScheme;
    final bool isLight = colorScheme.brightness == Brightness.light;
    final Color baseLine = colorScheme.outline;
    final Color lineColor = isLight
        ? baseLine.withValues(alpha: UIConstants.timelineLineOpacityLight)
        : baseLine.withValues(alpha: UIConstants.timelineLineOpacityDark);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        widget.onButtonTap?.call(index);
      },
      child: SizedBox(
        height: 56, // 固定高度
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Container(
                  width: isSelected ? 44 : 36,
                  height: isSelected ? 44 : 36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(isSelected ? 22 : 18),
                    color: isSelected
                        ? (isLight
                              ? Colors.white.withValues(alpha: 0.25)
                              : colorScheme.primary.withValues(alpha: 0.2))
                        : Colors.white.withValues(alpha: 0.05),
                    border: isSelected
                        ? Border.all(
                            color: isLight
                                ? lineColor.withValues(alpha: 0.8)
                                : colorScheme.primary.withValues(alpha: 0.6),
                            width: 0.6,
                          )
                        : Border.all(
                            color: isLight
                                ? lineColor.withValues(alpha: 0.4)
                                : colorScheme.outline.withValues(alpha: 0.3),
                            width: 0.3,
                          ),
                  ),
                  child: Center(
                    child: Icon(
                      icon,
                      size: isSelected
                          ? UIConstants.dockedBarIconSize +
                                UIConstants.dockedBarSelectedIconSizeIncrease
                          : UIConstants.dockedBarIconSize,
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
            ),
            // Text(
            //   _getLabelForIndex(index),
            //   style: AppTypography.labelSmall.copyWith(
            //     color: isSelected ? colorScheme.primary : null,
            //     fontWeight: isSelected ? FontWeight.w600 : null,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
