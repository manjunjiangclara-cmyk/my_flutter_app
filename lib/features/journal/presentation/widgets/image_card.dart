import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/strings.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
import 'package:my_flutter_app/core/utils/image_path_migration_service.dart';

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
  String? _validImagePath;
  bool _isLoading = true;
  final ImagePathMigrationService _migrationService =
      ImagePathMigrationService();

  @override
  void initState() {
    super.initState();
    _validateAndMigrateImagePath();
  }

  Future<void> _validateAndMigrateImagePath() async {
    try {
      // Check if the original path is valid
      if (await _migrationService.isImagePathValid(widget.imagePath)) {
        setState(() {
          _validImagePath = widget.imagePath;
          _isLoading = false;
        });
        return;
      }

      // Try to migrate the path
      final migratedPath = await _migrationService.migrateImagePath(
        widget.imagePath,
      );
      setState(() {
        _validImagePath = migratedPath;
        _isLoading = false;
      });
    } catch (e) {
      print('❌ Error validating image path: $e');
      setState(() {
        _validImagePath = null;
        _isLoading = false;
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
    if (_isLoading) {
      return _buildLoadingWidget();
    }

    if (_validImagePath == null) {
      return _buildErrorWidget(context, AppStrings.imageNotFound, null);
    }

    final file = File(_validImagePath!);

    // Debug logging
    file.exists().then((exists) {
      print('🖼️ ImageCard - Path: $_validImagePath');
      print('🖼️ ImageCard - File exists: $exists');
      if (exists) {
        file.length().then((size) {
          print('🖼️ ImageCard - File size: $size bytes');
        });
      }
    });

    return Image.file(
      file,
      height: widget.imageHeight,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: _buildErrorWidget,
    );
  }

  Widget _buildLoadingWidget() {
    return Container(
      height: widget.imageHeight,
      color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildErrorWidget(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  ) {
    // Log the error for debugging
    print('ImageCard Error - Path: ${widget.imagePath}, Error: $error');

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
