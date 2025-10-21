import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
import 'package:my_flutter_app/features/journal/presentation/strings/journal_strings.dart';
import 'package:my_flutter_app/shared/presentation/widgets/liquid_glass_icon_button.dart';

class JournalAppBarOverlay extends StatelessWidget {
  final double statusBarHeight;
  final bool isVisible;
  final VoidCallback onClose;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onShareTap;

  const JournalAppBarOverlay({
    super.key,
    required this.statusBarHeight,
    required this.isVisible,
    required this.onClose,
    required this.onEdit,
    required this.onDelete,
    required this.onShareTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: IgnorePointer(
        ignoring: !isVisible,
        child: AnimatedSlide(
          offset: isVisible
              ? Offset.zero
              : const Offset(0, UIConstants.journalAppBarSlideHiddenOffsetY),
          duration: UIConstants.defaultAnimation,
          curve: Curves.easeOut,
          child: AnimatedOpacity(
            opacity: isVisible ? 1.0 : 0.0,
            duration: UIConstants.defaultAnimation,
            curve: Curves.easeOut,
            child: Container(
              height: statusBarHeight + kToolbarHeight,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).colorScheme.onSurface.withValues(
                      alpha: UIConstants.journalAppBarGradientStartOpacity,
                    ),
                    Theme.of(context).colorScheme.onSurface.withValues(
                      alpha: UIConstants.journalAppBarGradientEndOpacity,
                    ),
                  ],
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: statusBarHeight),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: UIConstants.journalContentPadding,
                      ),
                      child: LiquidGlassIconButton(
                        svgAssetPath: 'assets/icons/close.svg',
                        onPressed: onClose,
                        tooltip: JournalStrings.closeJournal,
                        iconSize: UIConstants.journalAppBarIconSizeSmall,
                        alwaysShowBackground: true,
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            right: UIConstants.journalAppBarIconPadding,
                          ),
                          child: LiquidGlassIconButton(
                            svgAssetPath: 'assets/icons/edit.svg',
                            onPressed: onEdit,
                            tooltip: JournalStrings.editJournal,
                            iconSize: UIConstants.journalAppBarIconSizeSmall,
                            alwaysShowBackground: true,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            right: UIConstants.journalAppBarIconPadding,
                          ),
                          child: LiquidGlassIconButton(
                            svgAssetPath: 'assets/icons/delete.svg',
                            onPressed: onDelete,
                            tooltip: JournalStrings.deleteJournal,
                            iconSize: UIConstants.journalAppBarIconSizeSmall,
                            alwaysShowBackground: true,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            right: UIConstants.journalAppBarIconPadding,
                          ),
                          child: LiquidGlassIconButton(
                            svgAssetPath: 'assets/icons/share.svg',
                            onPressed: onShareTap,
                            tooltip: JournalStrings.shareJournal,
                            iconSize: UIConstants.journalAppBarIconSizeSmall,
                            alwaysShowBackground: true,
                          ),
                        ),
                      ],
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
}
