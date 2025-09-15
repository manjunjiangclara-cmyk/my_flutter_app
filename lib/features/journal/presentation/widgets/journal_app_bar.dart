import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/router/navigation_helper.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
import 'package:my_flutter_app/features/journal/presentation/strings/journal_strings.dart';

/// App bar widget for journal view screen
class JournalAppBar extends StatelessWidget {
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onShare;

  const JournalAppBar({super.key, this.onEdit, this.onDelete, this.onShare});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => NavigationHelper.goBack(context),
        tooltip: JournalStrings.closeJournal,
      ),
      actions: [
        _buildActionButton(
          icon: Icons.edit_outlined,
          onPressed: onEdit,
          tooltip: JournalStrings.editJournal,
        ),
        _buildActionButton(
          icon: Icons.delete_outline,
          onPressed: onDelete,
          tooltip: JournalStrings.deleteJournal,
        ),
        _buildActionButton(
          icon: Icons.ios_share,
          onPressed: onShare,
          tooltip: JournalStrings.shareJournal,
        ),
      ],
      floating: true,
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    VoidCallback? onPressed,
    required String tooltip,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: UIConstants.journalAppBarIconPadding,
      ),
      child: IconButton(
        icon: Icon(icon),
        iconSize: UIConstants.journalAppBarIconSize,
        onPressed: onPressed,
        tooltip: tooltip,
      ),
    );
  }
}
