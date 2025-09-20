import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/router/navigation_helper.dart';
import 'package:my_flutter_app/features/journal/presentation/strings/journal_strings.dart';
import 'package:my_flutter_app/shared/presentation/widgets/action_button.dart';

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
        icon: Icon(Platform.isIOS ? CupertinoIcons.xmark : Icons.close),
        onPressed: () => NavigationHelper.goBack(context),
        tooltip: JournalStrings.closeJournal,
      ),
      actions: [
        ActionButton(
          icon: Platform.isIOS ? CupertinoIcons.pencil : Icons.edit_outlined,
          onPressed: onEdit,
          tooltip: JournalStrings.editJournal,
        ),
        ActionButton(
          icon: Platform.isIOS ? CupertinoIcons.trash : Icons.delete_outline,
          onPressed: onDelete,
          tooltip: JournalStrings.deleteJournal,
        ),
        ActionButton(
          icon: Platform.isIOS ? CupertinoIcons.share : Icons.ios_share,
          onPressed: onShare,
          tooltip: JournalStrings.shareJournal,
        ),
      ],
      floating: true,
    );
  }
}
