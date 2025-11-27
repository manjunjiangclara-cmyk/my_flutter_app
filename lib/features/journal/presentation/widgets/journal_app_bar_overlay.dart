import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
import 'package:my_flutter_app/features/journal/presentation/strings/journal_strings.dart';
import 'package:my_flutter_app/shared/presentation/widgets/action_button.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final startOpacity = isDark
        ? UIConstants.journalAppBarGradientStartOpacity * 0.6
        : UIConstants.journalAppBarGradientStartOpacity;
    final endOpacity = UIConstants.journalAppBarGradientEndOpacity;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: IgnorePointer(
        ignoring: !isVisible,
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
                  Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: startOpacity),
                  Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: endOpacity),
                ],
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                top: statusBarHeight - UIConstants.smallPadding,
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: UIConstants.journalContentPadding,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.shadow
                                .withValues(
                                  alpha: UIConstants
                                      .journalAppBarActionShadowOpacity,
                                ),
                            blurRadius:
                                UIConstants.journalAppBarActionShadowBlur,
                            offset: const Offset(
                              0,
                              UIConstants.journalAppBarActionShadowOffsetY,
                            ),
                          ),
                        ],
                      ),
                      child: ActionButton.circular(
                        svgAssetPath: 'assets/icons/close.svg',
                        onPressed: onClose,
                        tooltip: JournalStrings.closeJournal,
                        iconSize: 18.0,
                        padding: const EdgeInsets.all(6.0),
                        iconColor: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
