import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
import 'package:my_flutter_app/features/compose/presentation/widgets/photo_viewer.dart';

class PhotoAttachments extends StatelessWidget {
  final List<String> photoPaths;
  final Function(int) onRemovePhoto;

  const PhotoAttachments({
    super.key,
    required this.photoPaths,
    required this.onRemovePhoto,
  });

  @override
  Widget build(BuildContext context) {
    if (photoPaths.isEmpty) return const SizedBox.shrink();

    return _buildSimpleGrid(context);
  }

  Widget _buildSimpleGrid(BuildContext context) {
    final photoSize = _getPhotoSize(context);

    return Wrap(
      spacing: UIConstants.photoGridSpacing,
      runSpacing: UIConstants.photoGridSpacing,
      children: photoPaths.asMap().entries.map((entry) {
        final index = entry.key;
        final photoPath = entry.value;
        return SizedBox(
          width: photoSize,
          height: photoSize,
          child: _buildPhotoItem(context, photoPath, index),
        );
      }).toList(),
    );
  }

  double _getPhotoSize(BuildContext context) {
    // Calculate size based on screen width - photos per row
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = UIConstants.defaultPadding * 2; // Left and right padding
    final spacing = UIConstants.photoGridSpacing * 2; // Spacing between photos
    final photoSize =
        (screenWidth - padding - spacing) / UIConstants.photosPerRow;

    // Set a reasonable minimum and maximum size
    return photoSize.clamp(UIConstants.photoMinSize, UIConstants.photoMaxSize);
  }

  Widget _buildPhotoItem(BuildContext context, String photoPath, int index) {
    return GestureDetector(
      onTap: () => _openPhotoViewer(context, index),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(UIConstants.defaultRadius),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(
              alpha: UIConstants.photoBorderOpacity,
            ),
            width: UIConstants.photoBorderWidth,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(UIConstants.defaultRadius),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.file(
                  File(photoPath),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Theme.of(context).colorScheme.outline.withValues(
                        alpha: UIConstants.photoErrorBackgroundOpacity,
                      ),
                      child: Icon(
                        Icons.broken_image,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        size: UIConstants.photoAttachmentIconSize,
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                top: UIConstants.photoAttachmentCloseButtonPadding,
                right: UIConstants.photoAttachmentCloseButtonPadding,
                child: GestureDetector(
                  onTap: () => onRemovePhoto(index),
                  child: Container(
                    padding: const EdgeInsets.all(
                      UIConstants.photoAttachmentCloseButtonPadding,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest
                          .withValues(alpha: 0.8),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      size: UIConstants.photoAttachmentCloseIconSize,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openPhotoViewer(BuildContext context, int initialIndex) {
    PhotoViewer.show(
      context: context,
      photoPaths: photoPaths,
      initialIndex: initialIndex,
    );
  }
}
