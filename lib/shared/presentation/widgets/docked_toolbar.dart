import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_flutter_app/core/theme/colors.dart';
import 'package:my_flutter_app/core/theme/fonts.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';

class DockedToolbarItem {
  final String emoji;
  final String label;

  const DockedToolbarItem({required this.emoji, required this.label});
}

class DockedToolbar extends StatelessWidget {
  final List<DockedToolbarItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final bool isVisible;

  const DockedToolbar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.isVisible = true,
  }) : assert(items.length >= 2);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final mediaQuery = MediaQuery.of(context);
    final bool keyboardOpen = mediaQuery.viewInsets.bottom > 0;
    final bool hasBottomSafeArea = mediaQuery.padding.bottom > 0;
    final double slideOutFraction =
        1.0 + (UIConstants.dockedBarBottomOffset / UIConstants.dockedBarHeight);

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
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        UIConstants.dockedBarRadius,
                      ),
                      border: Border.all(
                        color: colorScheme.primary.withValues(
                          alpha: UIConstants.dockedBarAccentBorderOpacity,
                        ),
                        width: UIConstants.dockedBarAccentBorderWidth,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadowTint.withValues(
                            alpha: UIConstants.dockedBarShadowOpacity,
                          ),
                          blurRadius: UIConstants.dockedBarShadowBlur,
                          offset: Offset(0, UIConstants.dockedBarShadowOffsetY),
                          spreadRadius: UIConstants.dockedBarShadowSpread,
                        ),
                        BoxShadow(
                          color: AppColors.shadowTint.withValues(
                            alpha: UIConstants.dockedBarShadow2Opacity,
                          ),
                          blurRadius: UIConstants.dockedBarShadow2Blur,
                          offset: Offset(
                            0,
                            UIConstants.dockedBarShadow2OffsetY,
                          ),
                          spreadRadius: UIConstants.dockedBarShadow2Spread,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        UIConstants.dockedBarRadius,
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: UIConstants.barBlurSigma,
                          sigmaY: UIConstants.barBlurSigma,
                        ),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: colorScheme.surface.withValues(
                              alpha: UIConstants.barOverlayOpacity,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  UIConstants.dockedBarHorizontalPadding,
                              vertical: 0.0,
                            ),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: UIConstants.dockedBarHeight,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
        ),
      ),
    );
  }
}

class _DockedToolbarButton extends StatelessWidget {
  final DockedToolbarItem item;
  final bool isSelected;
  final VoidCallback onPressed;

  const _DockedToolbarButton({
    required this.item,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final Color baseColor = isSelected
        ? colorScheme.primary
        : colorScheme.onSurfaceVariant;

    return Expanded(
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(UIConstants.mediumRadius),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 0.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: UIConstants.dockedBarIconPadding,
                  vertical: UIConstants.tinyPadding,
                ),
                decoration: isSelected
                    ? BoxDecoration(
                        color: baseColor.withValues(
                          alpha: UIConstants.dockedBarActiveOverlayOpacity,
                        ),
                        borderRadius: BorderRadius.circular(
                          UIConstants.mediumRadius,
                        ),
                      )
                    : null,
                child: Text(
                  item.emoji,
                  style: AppTypography.titleMedium.copyWith(
                    color: baseColor,
                    fontSize: UIConstants.dockedBarIconSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: UIConstants.tinyPadding),
              Text(
                item.label,
                style: AppTypography.labelSmall.copyWith(color: baseColor),
              ),
              SizedBox(height: UIConstants.extraSmallPadding),
            ],
          ),
        ),
      ),
    );
  }
}
