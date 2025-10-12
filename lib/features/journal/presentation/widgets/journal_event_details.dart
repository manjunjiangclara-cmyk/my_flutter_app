import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/fonts.dart';
import 'package:my_flutter_app/core/theme/spacings.dart';
import 'package:my_flutter_app/features/journal/presentation/strings/journal_strings.dart';

/// Event details header widget for journal view
class JournalEventDetails extends StatelessWidget {
  final String date;
  final String? location;

  const JournalEventDetails({super.key, required this.date, this.location});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            date,
            style: AppTypography.titleMedium,
            semanticsLabel: JournalStrings.journalDateLabel,
          ),
        ),
        if (location != null) ...[
          const SizedBox(width: Spacing.sm),
          _buildLocationChip(context, location!),
        ],
      ],
    );
  }

  Widget _buildLocationChip(BuildContext context, String location) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(JournalStrings.locationEmoji, style: AppTypography.labelSmall),
        const SizedBox(width: Spacing.xs),
        Flexible(
          child: Text(
            location,
            style: AppTypography.labelSmall,
            overflow: TextOverflow.ellipsis,
            semanticsLabel: JournalStrings.journalLocationLabel,
          ),
        ),
      ],
    );
  }
}
