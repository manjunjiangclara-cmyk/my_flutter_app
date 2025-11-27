import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/spacings.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
import 'package:my_flutter_app/core/utils/date_formatter.dart';
import 'package:my_flutter_app/features/journal/presentation/widgets/journal_header_image.dart';
import 'package:my_flutter_app/features/journal/presentation/widgets/journal_title_header.dart';
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
                bottom: UIConstants.defaultPadding,
              ),
              child: RepaintBoundary(
                key: captureKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _JournalHeaderImage(imagePaths: journal.imagePaths),
                    JournalTitleHeader(
                      date: DateFormatter.formatJournalDate(journal.createdAt),
                      location: journal.location,
                      locationTypes: journal.locationTypes,
                    ),
                    const SizedBox(height: Spacing.xxl),
                    JournalContentSection(content: journal.content),
                    _JournalImageGallery(imagePaths: journal.imagePaths),
                    _JournalTags(tags: journal.tags),
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

class _JournalImageGallery extends StatelessWidget {
  final List<String> imagePaths;

  const _JournalImageGallery({required this.imagePaths});

  @override
  Widget build(BuildContext context) {
    final total = imagePaths.length;
    final modulo = total % UIConstants.journalImageGalleryColumns;
    final hideHeader = modulo == 0 || modulo == 2;

    final config = hideHeader
        ? const ImageGalleryConfig(
            crossAxisCount: UIConstants.journalImageGalleryColumns,
            crossAxisSpacing: UIConstants.journalImageGallerySpacing,
            mainAxisSpacing: UIConstants.journalImageGallerySpacing,
            childAspectRatio: 1.0,
            itemHeight: UIConstants.journalImageGalleryItemHeight,
            showRemoveButton: false,
            enableFullscreenViewer: true,
            skipFirstPhoto: false,
            preferTwoColumnsWhenRemainderTwo: true,
          )
        : ImageGalleryConfig.journalConfig;

    // Check if gallery will actually display anything
    // For journalConfig, skipFirstPhoto is true, so if there's only 1 photo, it returns empty
    final filteredPaths = config.skipFirstPhoto && imagePaths.length <= 1
        ? []
        : config.skipFirstPhoto
        ? imagePaths.skip(1).toList()
        : imagePaths;

    if (filteredPaths.isEmpty) {
      // Return single spacing when no images to maintain consistent spacing
      return const SizedBox(height: Spacing.xxl);
    }

    return Column(
      children: [
        const SizedBox(height: Spacing.xxl),
        ImageGallery(imagePaths: imagePaths, config: config),
        const SizedBox(height: Spacing.xxl),
      ],
    );
  }
}

class _JournalHeaderImage extends StatelessWidget {
  final List<String> imagePaths;

  const _JournalHeaderImage({required this.imagePaths});

  @override
  Widget build(BuildContext context) {
    final shouldShow =
        (imagePaths.length % UIConstants.journalImageGalleryColumns) == 1;

    if (!shouldShow) {
      return const SizedBox(height: Spacing.xxl);
    }

    return Column(
      children: [
        JournalHeaderImage(imagePaths: imagePaths),
        SizedBox(height: Spacing.xxl),
      ],
    );
  }
}

class _JournalTags extends StatelessWidget {
  final List<String> tags;

  const _JournalTags({required this.tags});

  @override
  Widget build(BuildContext context) {
    if (tags.isEmpty) {
      return const SizedBox.shrink();
    }

    return TagChips(tags: tags);
  }
}
