import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/strings.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
import 'package:my_flutter_app/core/utils/image_widget_utils.dart';

class ImageCard extends StatefulWidget {
  final String imagePath;
  final double imageHeight;

  const ImageCard({
    super.key,
    required this.imagePath,
    this.imageHeight = UIConstants.defaultImageSize * 1.5,
  });

  @override
  State<ImageCard> createState() => _ImageCardState();
}

class _ImageCardState extends State<ImageCard> {
  String? _absoluteImagePath;
  bool _isConvertingPath = true;

  @override
  void initState() {
    super.initState();
    _convertToAbsolutePath();
  }

  Future<void> _convertToAbsolutePath() async {
    await ImageWidgetUtils.convertToAbsolutePath(
      imagePath: widget.imagePath,
      onPathConverted: (absolutePath) {
        setState(() {
          _absoluteImagePath = absolutePath;
          _isConvertingPath = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(UIConstants.largeRadius),
      child: _buildImage(),
    );
  }

  Widget _buildImage() {
    // Show modal placeholder while converting path
    if (_isConvertingPath) {
      return ImageWidgetUtils.buildLoadingPlaceholder(
        context: context,
        height: widget.imageHeight,
        width: double.infinity,
      );
    }

    // Show error if path conversion failed
    if (_absoluteImagePath == null) {
      return _buildErrorWidget(context, AppStrings.imageNotFound, null);
    }

    final file = File(_absoluteImagePath!);

    return Image.file(
      file,
      height: widget.imageHeight,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: _buildErrorWidget,
    );
  }

  Widget _buildErrorWidget(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  ) {
    return Container(
      height: widget.imageHeight,
      color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.broken_image_outlined,
              size: UIConstants.largeIconSize,
              color: Theme.of(
                context,
              ).colorScheme.onSurfaceVariant.withOpacity(0.6),
            ),
            const SizedBox(height: 8),
            Text(
              AppStrings.imageUnavailable,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurfaceVariant.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
