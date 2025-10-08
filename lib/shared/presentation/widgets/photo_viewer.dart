import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';

class PhotoViewer extends StatefulWidget {
  final List<String> photoPaths;
  final int initialIndex;

  const PhotoViewer({
    super.key,
    required this.photoPaths,
    this.initialIndex = 0,
  });

  @override
  State<PhotoViewer> createState() => _PhotoViewerState();

  static void show({
    required BuildContext context,
    required List<String> photoPaths,
    int initialIndex = 0,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            PhotoViewer(photoPaths: photoPaths, initialIndex: initialIndex),
        fullscreenDialog: true,
      ),
    );
  }
}

class _PhotoViewerState extends State<PhotoViewer> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          // Photo viewer
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: widget.photoPaths.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Center(
                  child: InteractiveViewer(
                    minScale: UIConstants.photoViewerMinScale,
                    maxScale: UIConstants.photoViewerMaxScale,
                    child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Image.file(
                          File(widget.photoPaths[index]),
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
                              child: Center(
                                child: Icon(
                                  Icons.broken_image,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                  size: UIConstants.photoViewerErrorIconSize,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // Top controls - only show image counter
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: UIConstants.defaultPadding,
                  vertical: UIConstants.smallPadding,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Theme.of(context).colorScheme.surface.withValues(
                        alpha: UIConstants.photoViewerGradientOpacity,
                      ),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    const Spacer(),
                    Text(
                      '${_currentIndex + 1} / ${widget.photoPaths.length}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: UIConstants.photoViewerCounterFontSize,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
