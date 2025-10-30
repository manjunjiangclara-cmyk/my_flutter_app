import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/router/navigation_helper.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
import 'package:my_flutter_app/features/journal/presentation/strings/journal_strings.dart';
import 'package:my_flutter_app/shared/presentation/widgets/round_icon_button.dart';

/// App bar widget for journal view screen
class JournalAppBar extends StatelessWidget {
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onShare;

  const JournalAppBar({super.key, this.onEdit, this.onDelete, this.onShare});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      leading: Padding(
        padding: const EdgeInsets.only(left: UIConstants.journalContentPadding),
        child: RoundIconButton(
          svgAssetPath: 'assets/icons/close.svg',
          onPressed: () => NavigationHelper.goBack(context),
          tooltip: JournalStrings.closeJournal,
          diameter: UIConstants.actionButtonDiameter,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(
            right: UIConstants.journalAppBarIconPadding,
          ),
          child: RoundIconButton(
            svgAssetPath: 'assets/icons/edit.svg',
            onPressed: onEdit,
            tooltip: JournalStrings.editJournal,
            diameter: UIConstants.actionButtonDiameter,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            right: UIConstants.journalAppBarIconPadding,
          ),
          child: RoundIconButton(
            svgAssetPath: 'assets/icons/delete.svg',
            onPressed: onDelete,
            tooltip: JournalStrings.deleteJournal,
            diameter: UIConstants.actionButtonDiameter,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            right: UIConstants.journalAppBarIconPadding,
          ),
          child: RoundIconButton(
            svgAssetPath: 'assets/icons/share.svg',
            onPressed: onShare,
            tooltip: JournalStrings.shareJournal,
            diameter: UIConstants.actionButtonDiameter,
          ),
        ),
      ],
      floating: true,
    );
  }
}
