import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
import 'package:my_flutter_app/core/utils/image_widget_utils.dart';

/// Custom image card for fullscreen viewing that maintains aspect ratio
class FullscreenImageCard extends StatefulWidget {
  final String imagePath;

  const FullscreenImageCard({super.key, required this.imagePath});

  @override
  State<FullscreenImageCard> createState() => _FullscreenImageCardState();
}

class _FullscreenImageCardState extends State<FullscreenImageCard> {
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
    final screenSize = MediaQuery.of(context).size;

    return SizedBox(
      height: screenSize.height,
      width: screenSize.width,
      child: _buildImage(context),
    );
  }

  Widget _buildImage(BuildContext context) {
    // Show modal placeholder while converting path
    if (_isConvertingPath) {
      return Center(
        child: ImageWidgetUtils.buildLoadingPlaceholder(
          context: context,
          height: UIConstants.photoViewerErrorIconSize,
          width: UIConstants.photoViewerErrorIconSize,
          backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(
            UIConstants.photoErrorBackgroundOpacity,
          ),
          iconColor: Theme.of(context).colorScheme.onSurface,
          iconSize: UIConstants.largeIconSize,
        ),
      );
    }

    // Show error if path conversion failed
    if (_absoluteImagePath == null) {
      return Center(
        child: ImageWidgetUtils.buildErrorPlaceholder(
          context: context,
          height: UIConstants.photoViewerErrorIconSize,
          width: UIConstants.photoViewerErrorIconSize,
          backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(
            UIConstants.photoErrorBackgroundOpacity,
          ),
          iconColor: Theme.of(context).colorScheme.onSurface,
          iconSize: UIConstants.largeIconSize,
        ),
      );
    }

    final file = File(_absoluteImagePath!);

    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: InteractiveViewer(
        minScale: UIConstants.photoViewerMinScale,
        maxScale: UIConstants.photoViewerMaxScale,
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: FittedBox(
            fit: BoxFit.contain,
            child: Image.file(
              file,
              errorBuilder: (context, error, stackTrace) =>
                  ImageWidgetUtils.buildErrorPlaceholder(
                    context: context,
                    height: UIConstants.photoViewerErrorIconSize,
                    width: UIConstants.photoViewerErrorIconSize,
                    backgroundColor: Theme.of(context).colorScheme.surface
                        .withOpacity(UIConstants.photoErrorBackgroundOpacity),
                    iconColor: Theme.of(context).colorScheme.onSurface,
                    iconSize: UIConstants.largeIconSize,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
