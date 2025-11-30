import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/fonts.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
import 'package:my_flutter_app/features/journal/presentation/strings/journal_strings.dart';

/// Content section widget for journal view
class JournalContentSection extends StatelessWidget {
  final String content;

  const JournalContentSection({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    // Split content into paragraphs (assuming double newlines separate paragraphs)
    final paragraphs = content
        .split('\n\n')
        .where((p) => p.trim().isNotEmpty)
        .toList();

    if (paragraphs.isEmpty) {
      return const SizedBox.shrink();
    }

    return Semantics(
      label: JournalStrings.journalContentLabel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < paragraphs.length; i++) ...<Widget>[
            Text(paragraphs[i], style: AppTypography.bodyLarge),
            if (i < paragraphs.length - 1) const SizedBox(height: UIConstants.defaultPadding),
          ],
        ],
      ),
    );
  }
}
