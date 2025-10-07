import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
import 'package:my_flutter_app/core/utils/image_path_service.dart';
import 'package:my_flutter_app/features/journal/presentation/strings/journal_strings.dart';

/// Header image widget for journal view
class JournalHeaderImage extends StatefulWidget {
  final List<String> imagePaths;

  const JournalHeaderImage({super.key, required this.imagePaths});

  @override
  State<JournalHeaderImage> createState() => _JournalHeaderImageState();
}

class _JournalHeaderImageState extends State<JournalHeaderImage> {
  String? _absoluteImagePath;
  static final ImagePathService _imagePathService = ImagePathService();

  @override
  void initState() {
    super.initState();
    if (widget.imagePaths.isNotEmpty) {
      _convertToAbsolutePath();
    }
  }

  Future<void> _convertToAbsolutePath() async {
    try {
      final absolutePath = await _imagePathService.getAbsolutePath(
        widget.imagePaths.first,
      );
      setState(() {
        _absoluteImagePath = absolutePath;
      });
    } catch (e) {
      print('❌ Error converting journal header image path: $e');
      setState(() {
        _absoluteImagePath = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // If no images or path conversion failed, return empty widget
    if (widget.imagePaths.isEmpty || _absoluteImagePath == null) {
      return const SizedBox.shrink();
    }

    return Container(
      height: UIConstants.journalHeaderImageHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.outline,
        borderRadius: BorderRadius.circular(UIConstants.defaultRadius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(UIConstants.defaultRadius),
        child: Image.file(
          File(_absoluteImagePath!),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              _buildPlaceholder(context),
        ),
      ),
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
