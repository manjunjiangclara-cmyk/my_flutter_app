import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_flutter_app/core/theme/colors.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';

class DockedToolbarItem {
  final IconData icon;
  final String label;

  const DockedToolbarItem({required this.icon, required this.label});
}

class DockedToolbar extends StatelessWidget {
  final List<DockedToolbarItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final bool isVisible;
  final double elevationT;

  const DockedToolbar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.isVisible = true,
    this.elevationT = 0.0,
  }) : assert(items.length >= 2);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final mediaQuery = MediaQuery.of(context);
    final bool keyboardOpen = mediaQuery.viewInsets.bottom > 0;
    final bool hasBottomSafeArea = mediaQuery.padding.bottom > 0;
    final double slideOutFraction =
        1.0 + (UIConstants.dockedBarBottomOffset / UIConstants.dockedBarHeight);

    double mix(double a, double b, double t) => a + (b - a) * t;
    final double t = elevationT.clamp(0.0, 1.0);
    final double stadiumRadius = UIConstants.dockedBarRadius;

    // Interpolated shadow layer 1
    final double shadow1Opacity = mix(
      UIConstants.dockedBarShadowOpacityMin,
      UIConstants.dockedBarShadowOpacityMax,
      t,
    );
    final double shadow1Blur = mix(
      UIConstants.dockedBarShadowBlurMin,
      UIConstants.dockedBarShadowBlurMax,
      t,
    );
    final double shadow1OffsetY = mix(
      UIConstants.dockedBarShadowOffsetYMin,
      UIConstants.dockedBarShadowOffsetYMax,
      t,
    );
    final double shadow1Spread = mix(
      UIConstants.dockedBarShadowSpreadMin,
      UIConstants.dockedBarShadowSpreadMax,
      t,
    );

    // Interpolated shadow layer 2
    final double shadow2Opacity = mix(
      UIConstants.dockedBarShadow2OpacityMin,
      UIConstants.dockedBarShadow2OpacityMax,
      t,
    );
    final double shadow2Blur = mix(
      UIConstants.dockedBarShadow2BlurMin,
      UIConstants.dockedBarShadow2BlurMax,
      t,
    );
    final double shadow2OffsetY = mix(
      UIConstants.dockedBarShadow2OffsetYMin,
      UIConstants.dockedBarShadow2OffsetYMax,
      t,
    );
    final double shadow2Spread = mix(
      UIConstants.dockedBarShadow2SpreadMin,
      UIConstants.dockedBarShadow2SpreadMax,
      t,
    );

    return AnimatedSlide(
      offset: isVisible ? Offset.zero : Offset(0, slideOutFraction),
      duration: UIConstants.dockedBarSlideDuration,
      curve: isVisible ? Curves.easeOutCubic : Curves.easeInCubic,
      child: AnimatedOpacity(
        opacity: isVisible ? 1.0 : 0.0,
        duration: UIConstants.dockedBarFadeDuration,
        curve: isVisible ? Curves.easeOut : Curves.easeIn,
        child: AnimatedScale(
          scale: isVisible ? 1.0 : UIConstants.dockedBarHiddenScale,
          duration: UIConstants.dockedBarScaleDuration,
          curve: isVisible ? Curves.easeOutBack : Curves.easeIn,
          child: SafeArea(
            top: false,
            bottom: false,
            child: Padding(
              padding: EdgeInsets.only(
                left: UIConstants.dockedBarMargin,
                right: UIConstants.dockedBarMargin,
                bottom: keyboardOpen
                    ? UIConstants.dockedBarMargin
                    : (hasBottomSafeArea
                          ? UIConstants.dockedBarMargin
                          : UIConstants.dockedBarMargin),
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: UIConstants.dockedBarMaxWidth,
                  ),
                  child: AnimatedContainer(
                    duration: UIConstants.defaultAnimation,
                    curve: Curves.easeOutCubic,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(stadiumRadius),
                      border: Border.all(
                        color: colorScheme.primary.withValues(
                          alpha: UIConstants.dockedBarAccentBorderOpacity,
                        ),
                        width: UIConstants.dockedBarAccentBorderWidth,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadowTint.withValues(
                            alpha: shadow1Opacity,
                          ),
                          blurRadius: shadow1Blur,
                          offset: Offset(0, shadow1OffsetY),
                          spreadRadius: shadow1Spread,
                        ),
                        BoxShadow(
                          color: AppColors.shadowTint.withValues(
                            alpha: shadow2Opacity,
                          ),
                          blurRadius: shadow2Blur,
                          offset: Offset(0, shadow2OffsetY),
                          spreadRadius: shadow2Spread,
                        ),
                      ],
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(stadiumRadius),
                        color: colorScheme.primary,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.15),
                          width: 1.0,
                        ),
                        boxShadow: [
                          // 主阴影 - 更柔和
                          BoxShadow(
                            color: AppColors.shadowTint.withValues(
                              alpha: shadow1Opacity * 0.6,
                            ),
                            blurRadius: shadow1Blur * 1.2,
                            offset: Offset(0, shadow1OffsetY * 0.8),
                            spreadRadius: shadow1Spread * 0.5,
                          ),
                          // 顶部高光边框 - 更细腻
                          BoxShadow(
                            color: Colors.white.withValues(alpha: 0.08),
                            blurRadius: 0,
                            offset: Offset(0, -0.5),
                            spreadRadius: 0,
                          ),
                        ],
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
                              for (int i = 0; i < items.length; i++)
                                _DockedToolbarButton(
                                  item: items[i],
                                  isSelected: i == currentIndex,
                                  onPressed: () {
                                    HapticFeedback.lightImpact();
                                    onTap(i);
                                  },
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DockedToolbarButton extends StatefulWidget {
  final DockedToolbarItem item;
  final bool isSelected;
  final VoidCallback onPressed;

  const _DockedToolbarButton({
    required this.item,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  State<_DockedToolbarButton> createState() => _DockedToolbarButtonState();
}

class _DockedToolbarButtonState extends State<_DockedToolbarButton>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _rotationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: UIConstants.fastAnimation,
      vsync: this,
    );
    _rotationController = AnimationController(
      duration: UIConstants.defaultAnimation,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.05).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bool isLight = colorScheme.brightness == Brightness.light;
    final Color baseLine = colorScheme.outline;
    final Color lineColor = isLight
        ? baseLine.withOpacity(UIConstants.timelineLineOpacityLight)
        : baseLine.withOpacity(UIConstants.timelineLineOpacityDark);

    final Color baseColor = widget.isSelected
        ? colorScheme.onSurface.withValues(alpha: 0.8)
        : lineColor.withValues(alpha: 0.7);

    return Expanded(
      child: GestureDetector(
        onTapDown: (_) {
          _scaleController.forward();
          _rotationController.forward();
        },
        onTapUp: (_) {
          _scaleController.reverse();
          _rotationController.reverse();
        },
        onTapCancel: () {
          _scaleController.reverse();
          _rotationController.reverse();
        },
        onTap: widget.onPressed,
        child: AnimatedBuilder(
          animation: Listenable.merge([_scaleAnimation, _rotationAnimation]),
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Transform.rotate(
                angle: _rotationAnimation.value,
                child: Container(
                  height: UIConstants.dockedBarHeight,
                  margin: EdgeInsets.symmetric(
                    horizontal: UIConstants.tinyPadding,
                    vertical: UIConstants.tinyPadding / 2,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      UIConstants.dockedBarRadius,
                    ),
                    // 移除按钮容器的背景色，只保留图标周围的圆形背景
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: UIConstants.fastAnimation,
                        curve: Curves.easeOutCubic,
                        padding: EdgeInsets.all(UIConstants.smallPadding),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.isSelected
                              ? Colors.white.withValues(alpha: 0.15)
                              : Colors.transparent,
                          border: widget.isSelected
                              ? Border.all(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  width: 0.5,
                                )
                              : null,
                        ),
                        child: Icon(
                          widget.item.icon,
                          color: baseColor,
                          size: widget.isSelected
                              ? UIConstants.dockedBarIconSize + 2
                              : UIConstants.dockedBarIconSize,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
