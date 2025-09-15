import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/spacings.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
import 'package:reorderables/reorderables.dart';

class ImageGallery extends StatelessWidget {
  final List<String> imageUrls;
  final double imageWidth;
  final double imageHeight;
  final bool canAddPhotos;
  final VoidCallback onAddPhotos;
  final void Function(int index)? onImageTap;
  final void Function(int index)? onImageDelete;
  final void Function(int oldIndex, int newIndex)? onReorder;

  const ImageGallery({
    required this.imageUrls,
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
      ...imageUrls.asMap().entries.map((entry) {
        int index = entry.key;
        String url = entry.value;

        return Stack(
          key: ValueKey(url),
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
                  child: Image.network(
                    url,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (
                          BuildContext context,
                          Object error,
                          StackTrace? stackTrace,
                        ) {
                          return Center(
                            child: Icon(
                              Icons.image,
                              size: UIConstants.mediumIconSize,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
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
            elevation: UIConstants.imageGalleryElevation,
            child: child,
          ),
        );
      },
      children: items,
    );
  }
}
