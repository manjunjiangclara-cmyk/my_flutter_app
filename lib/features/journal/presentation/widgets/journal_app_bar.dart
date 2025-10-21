import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/router/navigation_helper.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
import 'package:my_flutter_app/features/journal/presentation/strings/journal_strings.dart';
import 'package:my_flutter_app/shared/presentation/widgets/liquid_glass_icon_button.dart';

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
        child: LiquidGlassIconButton(
          svgAssetPath: 'assets/icons/close.svg',
          onPressed: () => NavigationHelper.goBack(context),
          tooltip: JournalStrings.closeJournal,
          alwaysShowBackground: true,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(
            right: UIConstants.journalAppBarIconPadding,
          ),
          child: LiquidGlassIconButton(
            svgAssetPath: 'assets/icons/edit.svg',
            onPressed: onEdit,
            tooltip: JournalStrings.editJournal,
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
            alwaysShowBackground: true,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            right: UIConstants.journalAppBarIconPadding,
          ),
          child: LiquidGlassIconButton(
            svgAssetPath: 'assets/icons/share.svg',
            onPressed: onShare,
            tooltip: JournalStrings.shareJournal,
            alwaysShowBackground: true,
          ),
        ),
      ],
      floating: true,
    );
  }
}
