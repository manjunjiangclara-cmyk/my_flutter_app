import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/spacings.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
import 'package:my_flutter_app/core/utils/date_formatter.dart';
import 'package:my_flutter_app/features/journal/presentation/widgets/journal_event_details.dart';
import 'package:my_flutter_app/features/journal/presentation/widgets/journal_header_image.dart';
import 'package:my_flutter_app/shared/presentation/widgets/image_gallery.dart';
import 'package:my_flutter_app/shared/presentation/widgets/tag_chip.dart';

import '../../../../shared/domain/entities/journal.dart';
import 'journal_content_section.dart';

class JournalContentScroll extends StatelessWidget {
  final Journal journal;
  final GlobalKey captureKey;
  final double statusBarHeight;

  const JournalContentScroll({
    super.key,
    required this.journal,
    required this.captureKey,
    required this.statusBarHeight,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(
                top: statusBarHeight,
                left: UIConstants.journalContentPadding,
                right: UIConstants.journalContentPadding,
                bottom: 0.0,
              ),
              child: RepaintBoundary(
                key: captureKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if ((journal.imagePaths.length %
                            UIConstants.journalImageGalleryColumns) ==
                        1)
                      JournalHeaderImage(imagePaths: journal.imagePaths),
                    const SizedBox(height: Spacing.lg),
                    JournalEventDetails(
                      date: DateFormatter.formatJournalDate(journal.createdAt),
                      location: journal.location,
                      locationTypes: journal.locationTypes,
                    ),
                    const SizedBox(height: Spacing.md),
                    JournalContentSection(content: journal.content),
                    const SizedBox(height: Spacing.lg),
                    if (journal.tags.isNotEmpty) ...[
                      TagChips(tags: journal.tags),
                    ],
                    Builder(
                      builder: (context) {
                        final total = journal.imagePaths.length;
                        final modulo =
                            total % UIConstants.journalImageGalleryColumns;
                        final hideHeader = modulo == 0 || modulo == 2;
                        return ImageGallery(
                          imagePaths: journal.imagePaths,
                          config: hideHeader
                              ? const ImageGalleryConfig(
                                  crossAxisCount:
                                      UIConstants.journalImageGalleryColumns,
                                  crossAxisSpacing:
                                      UIConstants.journalImageGallerySpacing,
                                  mainAxisSpacing:
                                      UIConstants.journalImageGallerySpacing,
                                  childAspectRatio: 1.0,
                                  itemHeight:
                                      UIConstants.journalImageGalleryItemHeight,
                                  showRemoveButton: false,
                                  enableFullscreenViewer: true,
                                  skipFirstPhoto: false,
                                  preferTwoColumnsWhenRemainderTwo: true,
                                )
                              : ImageGalleryConfig.journalConfig,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
