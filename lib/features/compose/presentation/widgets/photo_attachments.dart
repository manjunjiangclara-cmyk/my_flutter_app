import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';

class PhotoAttachments extends StatelessWidget {
  final List<String> photos;
  final Function(int) onRemovePhoto;

  const PhotoAttachments({
    super.key,
    required this.photos,
    required this.onRemovePhoto,
  });

  @override
  Widget build(BuildContext context) {
    if (photos.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: UIConstants.photoAttachmentHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: photos.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(
              right: UIConstants.photoAttachmentMargin,
            ),
            child: Stack(
              children: [
                Container(
                  width: UIConstants.photoAttachmentSize,
                  height: UIConstants.photoAttachmentSize,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      UIConstants.defaultRadius,
                    ),
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  child: Icon(
                    Icons.image,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    size: UIConstants.photoAttachmentIconSize,
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
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: UIConstants.photoAttachmentCloseIconSize,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
