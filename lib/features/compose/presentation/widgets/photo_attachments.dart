import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
import 'package:my_flutter_app/core/utils/image_path_service.dart';
import 'package:my_flutter_app/features/compose/presentation/widgets/photo_viewer.dart';

class PhotoAttachments extends StatefulWidget {
  final List<String> photoPaths;
  final Function(int) onRemovePhoto;

  const PhotoAttachments({
    super.key,
    required this.photoPaths,
    required this.onRemovePhoto,
  });

  @override
  State<PhotoAttachments> createState() => _PhotoAttachmentsState();
}

class _PhotoAttachmentsState extends State<PhotoAttachments> {
  final ImagePathService _imagePathService = ImagePathService();
  Map<String, String> _absolutePaths = {};

  @override
  void initState() {
    super.initState();
    _convertPaths();
  }

  @override
  void didUpdateWidget(PhotoAttachments oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.photoPaths != widget.photoPaths) {
      _convertPaths();
    }
  }

  Future<void> _convertPaths() async {
    final newAbsolutePaths = await _imagePathService.getAbsolutePaths(
      widget.photoPaths,
    );

    if (mounted) {
      setState(() {
        _absolutePaths = newAbsolutePaths;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.photoPaths.isEmpty) return const SizedBox.shrink();

    return _buildGrid(context);
  }

  Widget _buildGrid(BuildContext context) {
    final photoSize = _getPhotoSize(context);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: UIConstants.photosPerRow,
        crossAxisSpacing: UIConstants.photoGridSpacing,
        mainAxisSpacing: UIConstants.photoGridSpacing,
        childAspectRatio: 1.0,
      ),
      itemCount: widget.photoPaths.length,
      itemBuilder: (context, index) {
        final photoPath = widget.photoPaths[index];
        return SizedBox(
          width: photoSize,
          height: photoSize,
          child: _buildPhotoItem(context, photoPath, index),
        );
      },
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
    final absolutePath = _absolutePaths[photoPath] ?? photoPath;

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
                  File(absolutePath),
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
                  onTap: () => widget.onRemovePhoto(index),
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
    // Convert all photo paths to absolute paths for the viewer
    final absolutePhotoPaths = widget.photoPaths
        .map((path) => _absolutePaths[path] ?? path)
        .toList();

    PhotoViewer.show(
      context: context,
      photoPaths: absolutePhotoPaths,
      initialIndex: initialIndex,
    );
  }
}
