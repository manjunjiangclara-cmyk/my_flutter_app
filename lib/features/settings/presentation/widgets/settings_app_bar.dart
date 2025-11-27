import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/strings.dart';
import 'package:my_flutter_app/core/theme/fonts.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';

/// A custom app bar for the settings screen.
class SettingsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SettingsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: 0,
      title: Padding(
        padding: const EdgeInsets.only(left: UIConstants.defaultPadding),
        child: Text(
          '${AppStrings.settings} ⚙️',
          style: AppTypography.displayLarge,
        ),
      ),
      centerTitle: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      titleSpacing: 0,
      flexibleSpace: ClipRect(
        child: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: UIConstants.barBlurSigma,
                sigmaY: UIConstants.barBlurSigma,
              ),
              child: Container(
                color: Theme.of(context).colorScheme.surface.withValues(
                  alpha: UIConstants.barOverlayOpacity,
                ),
              ),
            ),
            // bottom edge fade to avoid a hard cutoff
            Align(
              alignment: Alignment.bottomCenter,
              child: IgnorePointer(
                child: Container(
                  height: UIConstants.barEdgeFadeHeight,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Theme.of(context).colorScheme.surface.withValues(
                          alpha: UIConstants.barEdgeFadeStartOpacity,
                        ),
                        Theme.of(
                          context,
                        ).colorScheme.surface.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
