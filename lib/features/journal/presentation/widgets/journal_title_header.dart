import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/fonts.dart';
import 'package:my_flutter_app/features/compose/presentation/models/place_types.dart';
import 'package:my_flutter_app/features/journal/presentation/strings/journal_strings.dart';
import 'package:my_flutter_app/shared/presentation/widgets/location_chip_display.dart';

import '../../../../core/theme/ui_constants.dart';

/// Event details header widget for journal view
class JournalTitleHeader extends StatelessWidget {
  final String date;
  final String? location;
  final List<String> locationTypes;

  const JournalTitleHeader({
    super.key,
    required this.date,
    this.location,
    this.locationTypes = const [],
  });

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
          const SizedBox(width: UIConstants.smallPadding),
          LocationChipDisplay(
            emoji: emojiForLocation(
              types: locationTypes,
              locationName: location!,
            ),
            name: location!,
          ),
        ],
      ],
    );
  }
}
