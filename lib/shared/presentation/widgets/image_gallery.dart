import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
import 'package:my_flutter_app/core/utils/image_path_service.dart';
import 'package:my_flutter_app/shared/presentation/widgets/photo_viewer.dart';
import 'package:reorderables/reorderables.dart';

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
  final bool skipFirstPhoto;
  final EdgeInsets? padding;
  final Widget? emptyWidget;
  final bool preferTwoColumnsWhenRemainderTwo;

  const ImageGalleryConfig({
    this.crossAxisCount = UIConstants.photosPerRow,
    this.crossAxisSpacing = UIConstants.photoGridSpacing,
    this.mainAxisSpacing = UIConstants.photoGridSpacing,
    this.childAspectRatio = 1.0,
    this.itemHeight,
    this.itemWidth,
    this.showRemoveButton = false,
    this.enableFullscreenViewer = true,
    this.skipFirstPhoto = false,
    this.padding,
    this.emptyWidget,
    this.preferTwoColumnsWhenRemainderTwo = false,
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
    skipFirstPhoto: true,
    preferTwoColumnsWhenRemainderTwo: true,
  );
}

/// Reusable image gallery widget that can display images in a grid
class ImageGallery extends StatefulWidget {
  final List<String> imagePaths;
  final ImageGalleryConfig config;
  final ValueChanged<int>? onImageTap;
  final ValueChanged<int>? onRemoveImage;
  final VoidCallback? onEmptyStateTap;
  final void Function(int oldIndex, int newIndex)? onReorder;

  const ImageGallery({
    super.key,
    required this.imagePaths,
    this.config = ImageGalleryConfig.composeConfig,
    this.onImageTap,
    this.onRemoveImage,
    this.onEmptyStateTap,
    this.onReorder,
  });

  @override
  State<ImageGallery> createState() => _ImageGalleryState();
}

class _ImageGalleryState extends State<ImageGallery> {
  final ImagePathService _imagePathService = ImagePathService();
  Map<String, String> _absolutePaths = {};
  bool _isLoadingPaths = false;
  final ScrollController _reorderScrollController = ScrollController();

  /// Get the filtered image paths based on skipFirstPhoto configuration
  List<String> get _filteredImagePaths {
    if (widget.config.skipFirstPhoto) {
      if (widget.imagePaths.length <= 1) {
        // Show nothing if there's only 1 photo or no photos
        return [];
      }
      // Skip the first photo and show the rest
      return widget.imagePaths.skip(1).toList();
    }
    return widget.imagePaths;
  }

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
  void dispose() {
    _reorderScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredPaths = _filteredImagePaths;
    if (filteredPaths.isEmpty) {
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
    final filteredPaths = _filteredImagePaths;
    final effectiveCrossAxisCount = _effectiveCrossAxisCount(
      filteredPaths.length,
    );
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: effectiveCrossAxisCount,
        crossAxisSpacing: widget.config.crossAxisSpacing,
        mainAxisSpacing: widget.config.mainAxisSpacing,
        childAspectRatio: widget.config.childAspectRatio,
      ),
      itemCount: filteredPaths.length,
      itemBuilder: (context, index) {
        return _buildLoadingItem();
      },
    );
  }

  Widget _buildImageGrid() {
    final filteredPaths = _filteredImagePaths;
    // When reordering is enabled, use a ReorderableWrap to allow drag-and-drop
    if (widget.onReorder != null) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final effectiveCrossAxisCount = _effectiveCrossAxisCount(
            filteredPaths.length,
          );
          final totalSpacing =
              (effectiveCrossAxisCount - 1) * widget.config.crossAxisSpacing;
          final availableWidth = constraints.maxWidth - totalSpacing;
          final itemWidth =
              widget.config.itemWidth ??
              (availableWidth / effectiveCrossAxisCount);
          final itemHeight =
              widget.config.itemHeight ??
              (itemWidth / widget.config.childAspectRatio);

          final ScrollController? inheritedPrimary =
              PrimaryScrollController.maybeOf(context);
          return PrimaryScrollController(
            controller: inheritedPrimary ?? _reorderScrollController,
            child: ReorderableWrap(
              spacing: widget.config.crossAxisSpacing,
              runSpacing: widget.config.mainAxisSpacing,
              onReorder: (oldIndex, newIndex) {
                final oldOriginal = _getOriginalIndex(oldIndex);
                final newOriginal = _getOriginalIndex(newIndex);
                widget.onReorder?.call(oldOriginal, newOriginal);
              },
              buildDraggableFeedback: (context, constraints, child) {
                return Opacity(
                  opacity: UIConstants.imageGalleryOpacity,
                  child: Material(
                    elevation: UIConstants.imageGalleryElevation,
                    child: child,
                  ),
                );
              },
              children: List.generate(filteredPaths.length, (index) {
                final imagePath = filteredPaths[index];
                return SizedBox(
                  key: ValueKey(imagePath),
                  width: itemWidth,
                  height: itemHeight,
                  child: _buildImageItem(imagePath, index),
                );
              }),
            ),
          );
        },
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _effectiveCrossAxisCount(filteredPaths.length),
        crossAxisSpacing: widget.config.crossAxisSpacing,
        mainAxisSpacing: widget.config.mainAxisSpacing,
        childAspectRatio: widget.config.childAspectRatio,
      ),
      itemCount: filteredPaths.length,
      itemBuilder: (context, index) {
        final imagePath = filteredPaths[index];
        return _buildImageItem(imagePath, index);
      },
    );
  }

  int _effectiveCrossAxisCount(int itemCount) {
    final baseCount = widget.config.crossAxisCount;
    if (!widget.config.preferTwoColumnsWhenRemainderTwo) return baseCount;
    if (itemCount == 0) return baseCount;
    return (itemCount % baseCount == 2)
        ? UIConstants.imageGalleryTwoColumnCount
        : baseCount;
  }

  Widget _buildLoadingItem() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(UIConstants.largeRadius),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(
            alpha: UIConstants.photoBorderOpacity,
          ),
          width: UIConstants.photoBorderWidth,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(UIConstants.largeRadius),
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
          borderRadius: BorderRadius.circular(UIConstants.largeRadius),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(
              alpha: UIConstants.photoBorderOpacity,
            ),
            width: UIConstants.photoBorderWidth,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(UIConstants.largeRadius),
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
      // Convert the filtered index back to the original index
      final originalIndex = _getOriginalIndex(index);
      widget.onImageTap!(originalIndex);
    } else if (widget.config.enableFullscreenViewer) {
      _openFullscreenViewer(index);
    }
  }

  void _openFullscreenViewer(int initialIndex) {
    // Convert all image paths to absolute paths for the viewer
    final absoluteImagePaths = widget.imagePaths
        .map((path) => _absolutePaths[path] ?? path)
        .toList();

    // Convert the filtered index back to the original index for the viewer
    final originalIndex = _getOriginalIndex(initialIndex);

    PhotoViewer.show(
      context: context,
      photoPaths: absoluteImagePaths,
      initialIndex: originalIndex,
    );
  }

  /// Convert filtered index back to original index
  int _getOriginalIndex(int filteredIndex) {
    if (widget.config.skipFirstPhoto && widget.imagePaths.length > 1) {
      return filteredIndex + 1;
    }
    return filteredIndex;
  }
}
