import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
import 'package:my_flutter_app/core/utils/image_path_service.dart';
import 'package:my_flutter_app/core/utils/image_widget_utils.dart';
import 'package:my_flutter_app/features/journal/presentation/strings/journal_strings.dart';
import 'package:my_flutter_app/shared/presentation/widgets/photo_viewer.dart';

/// Header image widget for journal view
class JournalHeaderImage extends StatefulWidget {
  final List<String> imagePaths;

  const JournalHeaderImage({super.key, required this.imagePaths});

  @override
  State<JournalHeaderImage> createState() => _JournalHeaderImageState();
}

class _JournalHeaderImageState extends State<JournalHeaderImage> {
  final ImagePathService _imagePathService = ImagePathService();
  String? _absoluteImagePath;
  Map<String, String> _absolutePaths = {};
  double _displayAspectRatio = UIConstants.journalHeaderDefaultAspectRatio;
  bool _isImageReady = false;
  ImageStream? _imageStream;
  ImageStreamListener? _imageStreamListener;

  @override
  void initState() {
    super.initState();
    if (widget.imagePaths.isNotEmpty) {
      _convertToAbsolutePath();
      _convertAllPathsToAbsolute();
    }
  }

  Future<void> _convertToAbsolutePath() async {
    await ImageWidgetUtils.convertToAbsolutePath(
      imagePath: widget.imagePaths.first,
      onPathConverted: (absolutePath) {
        if (!mounted) return;
        setState(() {
          _absoluteImagePath = absolutePath;
          // Prefer cached aspect ratio if available to stabilize first frame
          final cached = absolutePath == null
              ? null
              : ImageWidgetUtils.getCachedAspectRatio(absolutePath);
          if (cached != null && cached.isFinite && cached > 0) {
            _displayAspectRatio = cached;
          } else {
            _displayAspectRatio = UIConstants.journalHeaderDefaultAspectRatio;
          }
        });
        // Use image stream to get real size and mark ready
        if (absolutePath != null) {
          _startImageStream(absolutePath);
        }
      },
    );
  }

  void _startImageStream(String path) {
    if (_imageStream != null && _imageStreamListener != null) {
      _imageStream!.removeListener(_imageStreamListener!);
    }
    final provider = FileImage(File(path));
    final stream = provider.resolve(const ImageConfiguration());
    final listener = ImageStreamListener(
      (ImageInfo info, bool synchronousCall) {
        final image = info.image;
        final double ratio = image.width / image.height;
        ImageWidgetUtils.cacheAspectRatio(path, ratio);
        if (!mounted) return;
        setState(() {
          _displayAspectRatio = ratio;
          _isImageReady = true;
        });
      },
      onError: (dynamic _, __) {
        if (!mounted) return;
        setState(() {
          _isImageReady = false;
        });
      },
    );
    stream.addListener(listener);
    _imageStream = stream;
    _imageStreamListener = listener;
  }

  @override
  void dispose() {
    if (_imageStream != null && _imageStreamListener != null) {
      _imageStream!.removeListener(_imageStreamListener!);
    }
    super.dispose();
  }

  Future<void> _convertAllPathsToAbsolute() async {
    try {
      final absolutePaths = await _imagePathService.getAbsolutePaths(
        widget.imagePaths,
      );
      if (mounted) {
        setState(() {
          _absolutePaths = absolutePaths;
        });
      }
    } catch (e) {
      // Fallback to original paths if conversion fails
      if (mounted) {
        setState(() {
          _absolutePaths = Map.fromEntries(
            widget.imagePaths.map((path) => MapEntry(path, path)),
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // If no images or path conversion failed, return empty widget
    if (widget.imagePaths.isEmpty || _absoluteImagePath == null) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: UIConstants.enableImageShadows
          ? UIConstants.journalHeaderImageElevation
          : 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UIConstants.largeRadius),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _showImageFullscreen(context),
        child: _buildImage(context),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        final double width = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.of(context).size.width;
        final double height = width / _displayAspectRatio;

        return AnimatedContainer(
          duration: UIConstants.fastAnimation,
          curve: Curves.easeInOut,
          height: height,
          width: double.infinity,
          child: AnimatedSwitcher(
            duration: UIConstants.fastAnimation,
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            child: _isImageReady
                ? Image.file(
                    File(_absoluteImagePath!),
                    key: const ValueKey('headerImage'),
                    width: double.infinity,
                    height: height,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _buildPlaceholder(context),
                  )
                : Container(
                    key: const ValueKey('headerPlaceholder'),
                    color: Theme.of(
                      context,
                    ).colorScheme.outline.withOpacity(0.08),
                    child: _buildPlaceholder(context),
                  ),
          ),
        );
      },
    );
  }

  void _showImageFullscreen(BuildContext context) {
    // Convert all image paths to absolute paths for the viewer
    final absoluteImagePaths = widget.imagePaths
        .map((path) => _absolutePaths[path] ?? path)
        .toList();

    PhotoViewer.show(
      context: context,
      photoPaths: absoluteImagePaths,
      initialIndex: 0,
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Center(
      child: Icon(
        Platform.isIOS ? CupertinoIcons.photo : Icons.image,
        size: UIConstants.largeIconSize,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        semanticLabel: JournalStrings.journalImageLabel,
      ),
    );
  }
}
