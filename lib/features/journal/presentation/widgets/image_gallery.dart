import 'package:flutter/material.dart';
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
    this.imageWidth = 100,
    this.imageHeight = 100,
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
                  color: Colors.grey[300],
                  child: Image.network(
                    url,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (
                          BuildContext context,
                          Object error,
                          StackTrace? stackTrace,
                        ) {
                          return const Center(
                            child: Icon(
                              Icons.image,
                              size: 40,
                              color: Colors.grey,
                            ),
                          );
                        },
                  ),
                ),
              ),
            ),
            if (onImageDelete != null)
              Positioned(
                top: 2,
                right: 2,
                child: GestureDetector(
                  onTap: () => onImageDelete!(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 18,
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
              color: Colors.blueGrey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blueGrey.shade200, width: 1),
            ),
            child: Icon(
              Icons.add_photo_alternate_outlined,
              color: Colors.blueGrey.shade400,
              size: 30,
            ),
          ),
        ),
      );
    }

    return ReorderableWrap(
      spacing: 8,
      runSpacing: 8,
      onReorder: (oldIndex, newIndex) => onReorder?.call(oldIndex, newIndex),
      // 长按拖拽效果
      buildDraggableFeedback: (context, constraints, child) {
        return Opacity(
          opacity: 0.8,
          child: Material(elevation: 6, child: child),
        );
      },
      children: items,
    );
  }
}
