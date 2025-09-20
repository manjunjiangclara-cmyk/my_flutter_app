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
                    child: Image.file(
                      File(widget.photoPaths[index]),
                      fit: BoxFit.contain,
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
              );
            },
          ),

          // Top controls
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
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.close,
                        color: Theme.of(context).colorScheme.onSurface,
                        size: UIConstants.defaultIconSize,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${_currentIndex + 1} / ${widget.photoPaths.length}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: UIConstants.photoViewerCounterFontSize,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom controls (optional - for future features like delete, share, etc.)
          if (widget.photoPaths.length > 1)
            Positioned(
              bottom: 0,
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
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Theme.of(context).colorScheme.surface.withValues(
                          alpha: UIConstants.photoViewerGradientOpacity,
                        ),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Page indicator dots
                      ...List.generate(
                        widget.photoPaths.length,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: UIConstants.photoViewerDotSpacing,
                          ),
                          width: UIConstants.photoViewerDotSize,
                          height: UIConstants.photoViewerDotSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index == _currentIndex
                                ? Theme.of(context).colorScheme.onSurface
                                : Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withValues(
                                    alpha: UIConstants.photoViewerDotOpacity,
                                  ),
                          ),
                        ),
                      ),
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
