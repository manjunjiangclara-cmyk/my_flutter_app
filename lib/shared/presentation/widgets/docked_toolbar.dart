import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_flutter_app/core/theme/colors.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
import 'package:my_flutter_app/shared/presentation/widgets/liquid_glass_toolbar.dart';

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
  final bool useLiquidGlass;
  final double selectedProgress;

  const DockedToolbar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    required this.selectedProgress,
    this.isVisible = true,
    this.elevationT = 0.0,
    this.useLiquidGlass = false,
  }) : assert(items.length >= 2);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final mediaQuery = MediaQuery.of(context);
    final bool keyboardOpen = mediaQuery.viewInsets.bottom > 0;
    final bool hasBottomSafeArea = mediaQuery.padding.bottom > 0;

    // Calculate slide animation offset
    final double slideOutFraction =
        1.0 + (UIConstants.dockedBarBottomOffset / UIConstants.dockedBarHeight);

    // Helper function for smooth interpolation
    double mix(double a, double b, double t) => a + (b - a) * t;
    final double t = elevationT.clamp(0.0, 1.0);
    final double stadiumRadius = UIConstants.dockedBarRadius;

    // Calculate dynamic shadow properties based on elevation
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

    // Interpolated shadow layer 2 for depth
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

    // Main toolbar container with slide, fade, and scale animations
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
                  // Switch between LiquidGlass and Material docked bar
                  child: useLiquidGlass
                      ? LiquidGlassToolbar(
                          selectedIndex: currentIndex,
                          selectedProgress: selectedProgress,
                          onButtonTap: (index) {
                            HapticFeedback.lightImpact();
                            onTap(index);
                          },
                          icons: items.map((e) => e.icon).toList(),
                        )
                      : AnimatedContainer(
                          duration: UIConstants.defaultAnimation,
                          curve: Curves.easeOutCubic,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(stadiumRadius),
                            color: colorScheme.primary,
                            border: Border.all(
                              color: Colors.white.withValues(
                                alpha: UIConstants.dockedBarAccentBorderOpacity,
                              ),
                              width: UIConstants.dockedBarAccentBorderWidth,
                            ),
                            boxShadow: [
                              // Primary shadow
                              BoxShadow(
                                color: AppColors.shadowTint.withValues(
                                  alpha: shadow1Opacity,
                                ),
                                blurRadius: shadow1Blur,
                                offset: Offset(0, shadow1OffsetY),
                                spreadRadius: shadow1Spread,
                              ),
                              // Secondary shadow for depth
                              BoxShadow(
                                color: AppColors.shadowTint.withValues(
                                  alpha: shadow2Opacity,
                                ),
                                blurRadius: shadow2Blur,
                                offset: Offset(0, shadow2OffsetY),
                                spreadRadius: shadow2Spread,
                              ),
                              // Top highlight
                              BoxShadow(
                                color: Colors.white.withValues(
                                  alpha:
                                      UIConstants.dockedBarTopHighlightOpacity,
                                ),
                                blurRadius: 0,
                                offset: Offset(
                                  0,
                                  UIConstants.dockedBarTopHighlightOffset,
                                ),
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  UIConstants.dockedBarHorizontalPadding,
                              vertical: UIConstants.tinyPadding,
                            ),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: UIConstants.dockedBarHeight,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Render toolbar buttons
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
    );
  }
}

/// Individual button widget for the docked toolbar
/// Handles tap animations and visual states
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
    with SingleTickerProviderStateMixin {
  // Simplified animation system - only scale animation
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: UIConstants.fastAnimation,
      vsync: this,
    );

    _scaleAnimation =
        Tween<double>(
          begin: 1.0,
          end: UIConstants.dockedBarButtonScaleMin,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bool isLight = colorScheme.brightness == Brightness.light;
    final Color baseLine = colorScheme.outline;
    final Color lineColor = isLight
        ? baseLine.withValues(alpha: UIConstants.timelineLineOpacityLight)
        : baseLine.withValues(alpha: UIConstants.timelineLineOpacityDark);

    // Determine button color based on selection state
    final Color baseColor = widget.isSelected
        ? colorScheme.onSurface.withValues(
            alpha: UIConstants.dockedBarSelectedTextOpacity,
          )
        : lineColor.withValues(
            alpha: UIConstants.dockedBarUnselectedTextOpacity,
          );

    return Expanded(
      child: GestureDetector(
        onTapDown: (_) => _animationController.forward(),
        onTapUp: (_) => _animationController.reverse(),
        onTapCancel: () => _animationController.reverse(),
        onTap: widget.onPressed,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                height: UIConstants.dockedBarHeight,
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
                      color: widget.isSelected
                          ? Colors.white.withValues(
                              alpha:
                                  UIConstants.dockedBarSelectedOverlayOpacity,
                            )
                          : Colors.transparent,
                      border: widget.isSelected
                          ? Border.all(
                              color: Colors.white.withValues(
                                alpha:
                                    UIConstants.dockedBarSelectedBorderOpacity,
                              ),
                              width: UIConstants.dockedBarSelectedBorderWidth,
                            )
                          : null,
                    ),
                    child: TweenAnimationBuilder<Color?>(
                      duration: UIConstants.toolbarIconColorFadeDuration,
                      tween: ColorTween(begin: baseColor, end: baseColor),
                      builder: (context, color, _) => Icon(
                        widget.item.icon,
                        color: color,
                        size: widget.isSelected
                            ? UIConstants.dockedBarIconSize +
                                  UIConstants.dockedBarSelectedIconSizeIncrease
                            : UIConstants.dockedBarIconSize,
                      ),
                    ),
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
