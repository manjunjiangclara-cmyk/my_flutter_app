import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
import 'package:my_flutter_app/features/journal/presentation/strings/journal_strings.dart';
import 'package:my_flutter_app/shared/presentation/widgets/action_button.dart';

class JournalCloseButton extends StatelessWidget {
  final VoidCallback onPressed;

  const JournalCloseButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: UIConstants.journalContentPadding,
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow.withValues(
                    alpha: UIConstants.journalAppBarActionShadowOpacity,
                  ),
              blurRadius: UIConstants.journalAppBarActionShadowBlur,
              offset: const Offset(
                0,
                UIConstants.journalAppBarActionShadowOffsetY,
              ),
            ),
          ],
        ),
        child: ActionButton.circular(
          svgAssetPath: 'assets/icons/close.svg',
          onPressed: onPressed,
          tooltip: JournalStrings.closeJournal,
          iconSize: 18.0,
          padding: const EdgeInsets.all(6.0),
          iconColor: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}

