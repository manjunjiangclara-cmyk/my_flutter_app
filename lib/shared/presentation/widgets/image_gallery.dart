import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
import 'package:my_flutter_app/core/utils/image_path_service.dart';
import 'package:my_flutter_app/shared/presentation/widgets/photo_viewer.dart';

/// Configuration for image gallery display options
class ImageGalleryConfig {
  final int crossAxisCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final double childAspectRatio;
  final double? itemHeight;
  final double? itemWidth;
  final bool showRemoveButton;
  final bool enableFullscreenViewer;
  final EdgeInsets? padding;
  final Widget? emptyWidget;

  const ImageGalleryConfig({
    this.crossAxisCount = UIConstants.photosPerRow,
    this.crossAxisSpacing = UIConstants.photoGridSpacing,
    this.mainAxisSpacing = UIConstants.photoGridSpacing,
    this.childAspectRatio = 1.0,
    this.itemHeight,
    this.itemWidth,
    this.showRemoveButton = false,
    this.enableFullscreenViewer = true,
    this.padding,
    this.emptyWidget,
  });

  /// Configuration for compose screen photo attachments
  static const ImageGalleryConfig composeConfig = ImageGalleryConfig(
    crossAxisCount: UIConstants.photosPerRow,
    crossAxisSpacing: UIConstants.photoGridSpacing,
    mainAxisSpacing: UIConstants.photoGridSpacing,
    childAspectRatio: 1.0,
    showRemoveButton: true,
    enableFullscreenViewer: true,
  );

  /// Configuration for journal image gallery
  static const ImageGalleryConfig journalConfig = ImageGalleryConfig(
    crossAxisCount: UIConstants.journalImageGalleryColumns,
    crossAxisSpacing: UIConstants.journalImageGallerySpacing,
    mainAxisSpacing: UIConstants.journalImageGallerySpacing,
    childAspectRatio: 1.0,
    itemHeight: UIConstants.journalImageGalleryItemHeight,
    showRemoveButton: false,
    enableFullscreenViewer: true,
  );
}

/// Reusable image gallery widget that can display images in a grid
class ImageGallery extends StatefulWidget {
  final List<String> imagePaths;
  final ImageGalleryConfig config;
  final ValueChanged<int>? onImageTap;
  final ValueChanged<int>? onRemoveImage;
  final VoidCallback? onEmptyStateTap;

  const ImageGallery({
    super.key,
    required this.imagePaths,
    this.config = ImageGalleryConfig.composeConfig,
    this.onImageTap,
    this.onRemoveImage,
    this.onEmptyStateTap,
  });

  @override
  State<ImageGallery> createState() => _ImageGalleryState();
}

class _ImageGalleryState extends State<ImageGallery> {
  final ImagePathService _imagePathService = ImagePathService();
  Map<String, String> _absolutePaths = {};
  bool _isLoadingPaths = false;

  @override
  void initState() {
    super.initState();
    _convertPathsAsync();
  }

  @override
  void didUpdateWidget(ImageGallery oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imagePaths != widget.imagePaths) {
      _convertPathsAsync();
    }
  }

  Future<void> _convertPathsAsync() async {
    if (widget.imagePaths.isEmpty) {
      if (mounted) {
        setState(() {
          _absolutePaths = {};
          _isLoadingPaths = false;
        });
      }
      return;
    }

    if (mounted) {
      setState(() {
        _isLoadingPaths = true;
      });
    }

    try {
      final newAbsolutePaths = await _imagePathService.getAbsolutePaths(
        widget.imagePaths,
      );

      if (mounted) {
        setState(() {
          _absolutePaths = newAbsolutePaths;
          _isLoadingPaths = false;
        });
      }
    } catch (e) {
      // Fallback to original paths if conversion fails
      if (mounted) {
        setState(() {
          _absolutePaths = Map.fromEntries(
            widget.imagePaths.map((path) => MapEntry(path, path)),
          );
          _isLoadingPaths = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imagePaths.isEmpty) {
      return widget.config.emptyWidget ?? const SizedBox.shrink();
    }

    if (widget.config.padding != null) {
      return Padding(padding: widget.config.padding!, child: _buildGallery());
    }

    return _buildGallery();
  }

  Widget _buildGallery() {
    if (_isLoadingPaths) {
      return _buildLoadingGrid();
    }

    return _buildImageGrid();
  }

  Widget _buildLoadingGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.config.crossAxisCount,
        crossAxisSpacing: widget.config.crossAxisSpacing,
        mainAxisSpacing: widget.config.mainAxisSpacing,
        childAspectRatio: widget.config.childAspectRatio,
      ),
      itemCount: widget.imagePaths.length,
      itemBuilder: (context, index) {
        return _buildLoadingItem();
      },
    );
  }

  Widget _buildImageGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.config.crossAxisCount,
        crossAxisSpacing: widget.config.crossAxisSpacing,
        mainAxisSpacing: widget.config.mainAxisSpacing,
        childAspectRatio: widget.config.childAspectRatio,
      ),
      itemCount: widget.imagePaths.length,
      itemBuilder: (context, index) {
        final imagePath = widget.imagePaths[index];
        return _buildImageItem(imagePath, index);
      },
    );
  }

  Widget _buildLoadingItem() {
    return Container(
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
        child: Container(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: const Center(
            child: SizedBox(
              width: UIConstants.photoAttachmentIconSize,
              height: UIConstants.photoAttachmentIconSize,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageItem(String imagePath, int index) {
    final absolutePath = _absolutePaths[imagePath] ?? imagePath;

    return GestureDetector(
      onTap: () => _handleImageTap(index),
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
              Positioned.fill(child: _buildImage(absolutePath)),
              if (widget.config.showRemoveButton &&
                  widget.onRemoveImage != null)
                _buildRemoveButton(index),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(String absolutePath) {
    return Image.file(
      File(absolutePath),
      fit: BoxFit.cover,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) return child;
        return AnimatedOpacity(
          opacity: frame == null ? 0 : 1,
          duration: const Duration(milliseconds: 200),
          child: child,
        );
      },
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
    );
  }

  Widget _buildRemoveButton(int index) {
    return Positioned(
      top: UIConstants.photoAttachmentCloseButtonPadding,
      right: UIConstants.photoAttachmentCloseButtonPadding,
      child: GestureDetector(
        onTap: () => widget.onRemoveImage!(index),
        child: Container(
          padding: const EdgeInsets.all(
            UIConstants.photoAttachmentCloseButtonPadding,
          ),
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.8),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.close,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            size: UIConstants.photoAttachmentCloseIconSize,
          ),
        ),
      ),
    );
  }

  void _handleImageTap(int index) {
    if (widget.onImageTap != null) {
      widget.onImageTap!(index);
    } else if (widget.config.enableFullscreenViewer) {
      _openFullscreenViewer(index);
    }
  }

  void _openFullscreenViewer(int initialIndex) {
    // Convert all image paths to absolute paths for the viewer
    final absoluteImagePaths = widget.imagePaths
        .map((path) => _absolutePaths[path] ?? path)
        .toList();

    PhotoViewer.show(
      context: context,
      photoPaths: absoluteImagePaths,
      initialIndex: initialIndex,
    );
  }
}
