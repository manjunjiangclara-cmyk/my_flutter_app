import 'dart:io';
import 'dart:ui' as ui;

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
  double? _aspectRatio; // width / height

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
        });
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
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _aspectRatio = null;
      });
    }
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
    // While aspect ratio is unknown, keep a stable placeholder height
    if (_aspectRatio == null) {
      return SizedBox(
        height: UIConstants.journalHeaderImageHeight,
        width: double.infinity,
        child: _buildPlaceholder(context),
      );
    }

    return AspectRatio(
      aspectRatio: _aspectRatio!,
      child: Image.file(
        File(_absoluteImagePath!),
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            _buildPlaceholder(context),
      ),
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
