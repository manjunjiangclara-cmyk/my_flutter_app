import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/strings.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
import 'package:my_flutter_app/core/utils/image_path_service.dart';

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
  static final ImagePathService _imagePathService = ImagePathService();

  @override
  void initState() {
    super.initState();
    _convertToAbsolutePath();
  }

  Future<void> _convertToAbsolutePath() async {
    try {
      final absolutePath = await _imagePathService.getAbsolutePath(
        widget.imagePath,
      );
      setState(() {
        _absoluteImagePath = absolutePath;
        _isConvertingPath = false;
      });
    } catch (e) {
      setState(() {
        _absoluteImagePath = null;
        _isConvertingPath = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(UIConstants.defaultCardRadius),
      child: _buildImage(),
    );
  }

  Widget _buildImage() {
    // Show loading indicator while converting path
    if (_isConvertingPath) {
      return Container(
        height: widget.imageHeight,
        color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
        child: const Center(child: CircularProgressIndicator()),
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
