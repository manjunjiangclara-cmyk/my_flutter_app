import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/spacings.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
import 'package:reorderables/reorderables.dart';

class ImageGallery extends StatelessWidget {
  final List<String> imagePaths;
  final double imageWidth;
  final double imageHeight;
  final bool canAddPhotos;
  final VoidCallback onAddPhotos;
  final void Function(int index)? onImageTap;
  final void Function(int index)? onImageDelete;
  final void Function(int oldIndex, int newIndex)? onReorder;

  const ImageGallery({
    required this.imagePaths,
    this.imageWidth = UIConstants.defaultImageSize,
    this.imageHeight = UIConstants.defaultImageSize,
    required this.canAddPhotos,
    this.onAddPhotos = _defaultCallback,
    this.onImageTap,
    this.onImageDelete,
    this.onReorder,
    super.key,
  });

  static void _defaultCallback() {}

  @override
  Widget build(BuildContext context) {
    List<Widget> items = [
      ...imagePaths.asMap().entries.map((entry) {
        int index = entry.key;
        String path = entry.value;

        return Stack(
          key: ValueKey(path),
          children: [
            // 使用 Material + InkWell 提供长按反馈
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onImageTap?.call(index),
                onLongPress: () {}, // 可触发拖拽
                child: Container(
                  width: imageWidth,
                  height: imageHeight,
                  color: Theme.of(context).colorScheme.outline,
                  child: Image.file(
                    File(path),
                    fit: BoxFit.cover,
                    errorBuilder:
                        (
                          BuildContext context,
                          Object error,
                          StackTrace? stackTrace,
                        ) {
                          // Log the error for debugging
                          print(
                            'ImageGallery Error - Path: $path, Error: $error',
                          );
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.broken_image,
                                  size: UIConstants.mediumIconSize,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Image not found',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant,
                                      ),
                                ),
                              ],
                            ),
                          );
                        },
                  ),
                ),
              ),
            ),
            if (onImageDelete != null)
              Positioned(
                top: Spacing.xxs,
                right: Spacing.xxs,
                child: GestureDetector(
                  onTap: () => onImageDelete!(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      size: UIConstants.smallIconSize,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        );
      }),
    ];

    if (canAddPhotos) {
      items.add(
        GestureDetector(
          onTap: onAddPhotos,
          child: Container(
            width: imageWidth,
            height: imageHeight,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
              borderRadius: BorderRadius.circular(UIConstants.defaultRadius),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline,
                width: 1,
              ),
            ),
            child: Icon(
              Icons.add_photo_alternate_outlined,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              size: UIConstants.mediumIconSize,
            ),
          ),
        ),
      );
    }

    return ReorderableWrap(
      spacing: UIConstants.imageGallerySpacing,
      runSpacing: UIConstants.imageGalleryRunSpacing,
      onReorder: (oldIndex, newIndex) => onReorder?.call(oldIndex, newIndex),
      // 长按拖拽效果
      buildDraggableFeedback: (context, constraints, child) {
        return Opacity(
          opacity: UIConstants.imageGalleryOpacity,
          child: Material(
            elevation: UIConstants.enableImageShadows
                ? UIConstants.imageGalleryElevation
                : 0,
            child: child,
          ),
        );
      },
      children: items,
    );
  }
}
