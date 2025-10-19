import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/colors.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';

class LiquidGlassToolbar extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int>? onButtonTap;
  final List<IconData>? icons;

  const LiquidGlassToolbar({
    super.key,
    required this.selectedIndex,
    this.onButtonTap,
    this.icons,
  });

  @override
  State<LiquidGlassToolbar> createState() => _LiquidGlassToolbarState();
}

class _LiquidGlassToolbarState extends State<LiquidGlassToolbar> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  @override
  void didUpdateWidget(LiquidGlassToolbar oldWidget) {
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
      // Follow DockedToolbar sizing (height via inner ConstrainedBox)
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(UIConstants.dockedBarRadius),
        color: Colors.white.withValues(
          alpha: UIConstants.dockedBarTintOpacityMax,
        ),
        border: Border.all(
          color: lineColor.withValues(
            alpha: UIConstants.dockedBarAccentBorderOpacity,
          ),
          width: UIConstants.dockedBarAccentBorderWidth,
        ),
        boxShadow: [
          // Primary shadow for depth (match Docked defaults)
          BoxShadow(
            color: AppColors.shadowTint.withValues(
              alpha: UIConstants.dockedBarShadowOpacity,
            ),
            blurRadius: UIConstants.dockedBarShadowBlur,
            offset: Offset(0, UIConstants.dockedBarShadowOffsetY),
            spreadRadius: UIConstants.dockedBarShadowSpread,
          ),
          // Secondary shadow for more depth
          BoxShadow(
            color: AppColors.shadowTint.withValues(
              alpha: UIConstants.dockedBarShadow2Opacity,
            ),
            blurRadius: UIConstants.dockedBarShadow2Blur,
            offset: Offset(0, UIConstants.dockedBarShadow2OffsetY),
            spreadRadius: UIConstants.dockedBarShadow2Spread,
          ),
          // Top highlight
          BoxShadow(
            color: Colors.white.withValues(
              alpha: UIConstants.dockedBarTopHighlightOpacity,
            ),
            blurRadius: 0,
            offset: Offset(0, UIConstants.dockedBarTopHighlightOffset),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(UIConstants.dockedBarRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(UIConstants.dockedBarRadius),
              color: Colors.white.withValues(alpha: 0.1),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: UIConstants.dockedBarHorizontalPadding,
                vertical: UIConstants.tinyPadding,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: UIConstants.dockedBarHeight,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (int i = 0; i < 3; i++)
                      Expanded(
                        child: _buildButton(
                          (widget.icons != null && widget.icons!.length > i)
                              ? widget.icons![i]
                              : (i == 0
                                    ? Icons.chrome_reader_mode
                                    : (i == 1 ? Icons.edit : Icons.settings)),
                          i,
                        ),
                      ),
                  ],
                ),
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

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        widget.onButtonTap?.call(index);
      },
      child: Container(
        height: UIConstants.dockedBarHeight, // align with docked
        margin: EdgeInsets.symmetric(
          horizontal: UIConstants.tinyPadding,
          vertical: UIConstants.tinyPadding / 2,
        ),
        child: Center(
          child: AnimatedContainer(
            duration: UIConstants.fastAnimation,
            curve: Curves.easeOutCubic,
            padding: EdgeInsets.all(UIConstants.smallPadding),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected
                  ? Colors.white.withValues(
                      alpha: UIConstants.dockedBarSelectedOverlayOpacity,
                    )
                  : Colors.transparent,
              border: isSelected
                  ? Border.all(
                      color: Colors.white.withValues(
                        alpha: UIConstants.dockedBarSelectedBorderOpacity,
                      ),
                      width: UIConstants.dockedBarSelectedBorderWidth,
                    )
                  : null,
            ),
            child: TweenAnimationBuilder<Color?>(
              duration: UIConstants.toolbarIconColorFadeDuration,
              tween: ColorTween(
                begin: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurface.withValues(
                        alpha: UIConstants.liquidGlassUnselectedIconOpacity,
                      ),
                end: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurface.withValues(
                        alpha: UIConstants.liquidGlassUnselectedIconOpacity,
                      ),
              ),
              builder: (context, color, _) => Icon(
                icon,
                size: isSelected
                    ? UIConstants.dockedBarIconSize +
                          UIConstants.dockedBarSelectedIconSizeIncrease
                    : UIConstants.dockedBarIconSize,
                color: color,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
