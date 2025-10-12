import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
import 'package:my_flutter_app/shared/presentation/widgets/image_gallery.dart';

/// Image gallery widget for displaying all journal images
/// Uses the shared ImageGallery component with journal-specific configuration
class JournalImageGallery extends StatelessWidget {
  final List<String> imagePaths;

  const JournalImageGallery({super.key, required this.imagePaths});

  @override
  Widget build(BuildContext context) {
    if (imagePaths.isEmpty) {
      return const SizedBox.shrink();
    }

    return Semantics(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: UIConstants.defaultPadding),
          ImageGallery(
            imagePaths: imagePaths,
            config: ImageGalleryConfig.journalConfig,
          ),
        ],
      ),
    );
  }
}
