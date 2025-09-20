import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
import 'package:my_flutter_app/features/journal/presentation/strings/journal_strings.dart';

/// Header image widget for journal view
class JournalHeaderImage extends StatelessWidget {
  final List<String> imagePaths;

  const JournalHeaderImage({super.key, required this.imagePaths});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: UIConstants.journalHeaderImageHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.outline,
        borderRadius: BorderRadius.circular(UIConstants.defaultRadius),
      ),
      child: imagePaths.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(UIConstants.defaultRadius),
              child: Image.file(
                File(imagePaths.first),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _buildPlaceholder(context),
              ),
            )
          : SizedBox.shrink(),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Center(
      child: Icon(
        Platform.isIOS ? CupertinoIcons.photo : Icons.image,
        size: UIConstants.largeIconSize,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        semanticLabel: JournalStrings.journalImageLabel,
      ),
    );
  }
}
