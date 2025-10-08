import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
import 'package:my_flutter_app/core/utils/image_widget_utils.dart';
import 'package:my_flutter_app/features/journal/presentation/strings/journal_strings.dart';
import 'package:my_flutter_app/features/journal/presentation/widgets/fullscreen_image_card.dart';

/// Header image widget for journal view
class JournalHeaderImage extends StatefulWidget {
  final List<String> imagePaths;

  const JournalHeaderImage({super.key, required this.imagePaths});

  @override
  State<JournalHeaderImage> createState() => _JournalHeaderImageState();
}

class _JournalHeaderImageState extends State<JournalHeaderImage> {
  String? _absoluteImagePath;

  @override
  void initState() {
    super.initState();
    if (widget.imagePaths.isNotEmpty) {
      _convertToAbsolutePath();
    }
  }

  Future<void> _convertToAbsolutePath() async {
    await ImageWidgetUtils.convertToAbsolutePath(
      imagePath: widget.imagePaths.first,
      onPathConverted: (absolutePath) {
        setState(() {
          _absoluteImagePath = absolutePath;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // If no images or path conversion failed, return empty widget
    if (widget.imagePaths.isEmpty || _absoluteImagePath == null) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () => _showImageFullscreen(context),
      child: Container(
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
      ),
    );
  }

  void _showImageFullscreen(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            _ImageFullscreenView(
              imagePaths: widget.imagePaths,
              initialIndex: 0,
            ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 200),
        reverseTransitionDuration: const Duration(milliseconds: 200),
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

/// Fullscreen image viewer for journal header images
class _ImageFullscreenView extends StatefulWidget {
  final List<String> imagePaths;
  final int initialIndex;

  const _ImageFullscreenView({
    required this.imagePaths,
    required this.initialIndex,
  });

  @override
  State<_ImageFullscreenView> createState() => _ImageFullscreenViewState();
}

class _ImageFullscreenViewState extends State<_ImageFullscreenView> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: theme.colorScheme.surface,
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.imagePaths.length,
        itemBuilder: (context, index) {
          return Center(
            child: FullscreenImageCard(imagePath: widget.imagePaths[index]),
          );
        },
      ),
    );
  }
}
