import 'dart:io';
import 'dart:ui' as ui;

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

class _ImageCardState extends State<ImageCard>
    with AutomaticKeepAliveClientMixin {
  String? _absoluteImagePath;
  bool _isConvertingPath = true;
  double? _aspectRatio; // width / height

  @override
  void initState() {
    super.initState();
    _convertToAbsolutePath();
  }

  Future<void> _convertToAbsolutePath() async {
    await ImageWidgetUtils.convertToAbsolutePath(
      imagePath: widget.imagePath,
      onPathConverted: (absolutePath) {
        if (!mounted) return;
        setState(() {
          _absoluteImagePath = absolutePath;
          _isConvertingPath = false;
        });
        // If we already know the aspect ratio (primed by another screen), use it
        if (absolutePath != null) {
          final cached = ImageWidgetUtils.getCachedAspectRatio(absolutePath);
          if (cached != null && cached.isFinite && cached > 0) {
            if (!mounted) return;
            setState(() {
              _aspectRatio = cached;
            });
            return;
          }
        }
        _loadAspectRatio();
      },
    );
  }

  Future<void> _loadAspectRatio() async {
    final path = _absoluteImagePath;
    if (path == null) return;
    try {
      final file = File(path);
      final bytes = await file.readAsBytes();
      final ui.Codec codec = await ui.instantiateImageCodec(bytes);
      final ui.FrameInfo frame = await codec.getNextFrame();
      final ui.Image image = frame.image;
      final double ratio = image.width / image.height;
      if (!mounted) return;
      setState(() {
        _aspectRatio = ratio;
      });
      // Prime cache so detail screen can immediately stabilize layout
      ImageWidgetUtils.cacheAspectRatio(path, ratio);
    } catch (_) {
      // If decoding fails, keep aspect ratio null so we fall back to placeholder
      if (!mounted) return;
      setState(() {
        _aspectRatio = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Card(
      margin: EdgeInsets.zero,
      elevation: UIConstants.enableImageShadows
          ? UIConstants.memoryImageElevation
          : 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UIConstants.imageInnerRadius),
      ),
      surfaceTintColor: Colors.transparent,
      clipBehavior: Clip.antiAlias,
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
    // If we haven't decoded the aspect ratio yet, keep showing a stable placeholder
    if (_aspectRatio == null) {
      return ImageWidgetUtils.buildLoadingPlaceholder(
        context: context,
        height: widget.imageHeight,
        width: double.infinity,
      );
    }

    return AspectRatio(
      aspectRatio: _aspectRatio!,
      child: Image.file(
        file,
        width: double.infinity,
        fit: BoxFit.cover,
        gaplessPlayback: true,
        errorBuilder: _buildErrorWidget,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

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
