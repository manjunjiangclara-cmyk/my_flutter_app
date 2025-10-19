import 'dart:io';
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
    if (Platform.isIOS) {
      return Container(
        width: 240,
        height: 52,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          color: Colors.white.withValues(alpha: 0.1),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.2),
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                color: Colors.white.withValues(alpha: 0.1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildButton(Icons.book, 0),
                  _buildButton(Icons.edit, 1),
                  _buildButton(Icons.settings, 2),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      // Android fallback - 使用普通的 Material 设计
      return Container(
        width: 240,
        height: 52,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          color: Theme.of(context).colorScheme.primary,
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.15),
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildButton(Icons.book, 0),
            _buildButton(Icons.edit, 1),
            _buildButton(Icons.settings, 2),
          ],
        ),
      );
    }
  }

  Widget _buildButton(IconData icon, int index) {
    final isSelected = index == _selectedIndex;
    final colorScheme = Theme.of(context).colorScheme;
    final bool isLight = colorScheme.brightness == Brightness.light;

    // 获取 timeline 线条颜色
    final Color baseLine = colorScheme.outline;
    final Color lineColor = isLight
        ? baseLine.withOpacity(UIConstants.timelineLineOpacityLight)
        : baseLine.withOpacity(UIConstants.timelineLineOpacityDark);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        widget.onButtonTap?.call(index);
      },
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: isSelected
              ? Colors.white.withValues(alpha: 0.2)
              : Colors.transparent,
          border: isSelected
              ? Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 0.5,
                )
              : null,
        ),
        child: Icon(
          icon,
          size: 20,
          color: isSelected
              ? colorScheme
                    .primary // 选中状态使用 primary color
              : lineColor, // 未选中状态使用 timeline 线条颜色
        ),
      ),
    );
  }
}
