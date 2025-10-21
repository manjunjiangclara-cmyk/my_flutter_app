import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_flutter_app/core/theme/colors.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';

/// A liquid glass style icon button with customizable icon color and size
class LiquidGlassIconButton extends StatelessWidget {
  final IconData? icon;
  final String? svgAssetPath;
  final VoidCallback? onPressed;
  final String? tooltip;
  final double? iconSize;
  final Color? iconColor;
  final EdgeInsets? padding;
  final bool enabled;
  final bool isSelected;
  final bool alwaysShowBackground;

  const LiquidGlassIconButton({
    super.key,
    this.icon,
    this.svgAssetPath,
    this.onPressed,
    this.tooltip,
    this.iconSize,
    this.iconColor,
    this.padding,
    this.enabled = true,
    this.isSelected = false,
    this.alwaysShowBackground = false,
  }) : assert(
         icon != null || svgAssetPath != null,
         'Either icon or svgAssetPath must be provided',
       );

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final effectiveIconSize = iconSize ?? UIConstants.dockedBarIconSize;
    final effectivePadding =
        padding ?? EdgeInsets.all(UIConstants.smallPadding);

    // Determine icon color based on selection state and custom color
    final Color effectiveIconColor =
        iconColor ??
        (isSelected
            ? colorScheme.primary
            : colorScheme.onSurface.withValues(
                alpha: UIConstants.liquidGlassUnselectedIconOpacity,
              ));

    // Create the appropriate icon widget
    Widget iconWidget;
    if (svgAssetPath != null) {
      iconWidget = SvgPicture.asset(
        svgAssetPath!,
        width: effectiveIconSize,
        height: effectiveIconSize,
        colorFilter: ColorFilter.mode(effectiveIconColor, BlendMode.srcIn),
      );
    } else {
      iconWidget = Icon(
        icon!,
        size: effectiveIconSize,
        color: effectiveIconColor,
      );
    }

    return GestureDetector(
      onTap: enabled ? onPressed : null,
      child: Stack(
        children: [
          // Outer container with background and border
          Container(
            padding: effectivePadding,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: (isSelected || alwaysShowBackground)
                  ? (alwaysShowBackground
                        ? AppColors.liquidGlassIconBackground
                        : Colors.white.withValues(
                            alpha: UIConstants.dockedBarSelectedOverlayOpacity,
                          ))
                  : Colors.transparent,
              border: (isSelected || alwaysShowBackground)
                  ? Border.all(
                      color: Colors.white.withValues(
                        alpha: UIConstants.dockedBarSelectedBorderOpacity,
                      ),
                      width: UIConstants.dockedBarSelectedBorderWidth,
                    )
                  : null,
            ),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: (isSelected || alwaysShowBackground)
                    ? Border.all(
                        color: Colors.white.withValues(
                          alpha:
                              UIConstants.dockedBarSelectedBorderOpacity * 0.5,
                        ),
                        width: UIConstants.dockedBarSelectedBorderWidth * 0.5,
                      )
                    : null,
              ),
              child: TweenAnimationBuilder<Color?>(
                duration: UIConstants.toolbarIconColorFadeDuration,
                tween: ColorTween(
                  begin: effectiveIconColor,
                  end: effectiveIconColor,
                ),
                builder: (context, color, _) => iconWidget,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
