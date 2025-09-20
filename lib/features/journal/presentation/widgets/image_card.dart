import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';

class ImageCard extends StatelessWidget {
  final String imageUrl;
  final double imageHeight;

  const ImageCard({
    super.key,
    required this.imageUrl,
    this.imageHeight = UIConstants.defaultImageSize * 1.5,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(UIConstants.defaultCardRadius),
      child: _buildImage(),
    );
  }

  Widget _buildImage() {
    // Check if the imageUrl is a local file path or a network URL
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      // Network image
      return Image.network(
        imageUrl,
        height: imageHeight,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: _buildErrorWidget,
      );
    } else {
      // Local file image
      return Image.file(
        File(imageUrl),
        height: imageHeight,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: _buildErrorWidget,
      );
    }
  }

  Widget _buildErrorWidget(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  ) {
    return Container(
      height: imageHeight,
      color: Theme.of(context).colorScheme.outline,
      child: Center(
        child: Icon(
          Icons.broken_image,
          size: UIConstants.largeIconSize,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
