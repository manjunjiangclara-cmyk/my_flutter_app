import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
import 'package:my_flutter_app/features/journal/presentation/widgets/fullscreen_image_card.dart';
import 'package:my_flutter_app/features/journal/presentation/widgets/image_card.dart';

/// Image gallery widget for displaying all journal images
class JournalImageGallery extends StatelessWidget {
  final List<String> imagePaths;

  const JournalImageGallery({super.key, required this.imagePaths});

  @override
  Widget build(BuildContext context) {
    if (imagePaths.isEmpty) {
      return const SizedBox.shrink();
    }

    return Semantics(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: UIConstants.defaultPadding),
          _buildImageGrid(context),
        ],
      ),
    );
  }

  Widget _buildImageGrid(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: UIConstants.journalImageGalleryColumns,
        crossAxisSpacing: UIConstants.journalImageGallerySpacing,
        mainAxisSpacing: UIConstants.journalImageGallerySpacing,
        childAspectRatio: 1.0,
      ),
      itemCount: imagePaths.length,
      itemBuilder: (context, index) {
        return _buildImageCard(context, imagePaths[index], index);
      },
    );
  }

  Widget _buildImageCard(BuildContext context, String imagePath, int index) {
    return GestureDetector(
      onTap: () => _showImageFullscreen(context, index),
      child: ImageCard(
        imagePath: imagePath,
        imageHeight: UIConstants.journalImageGalleryItemHeight,
      ),
    );
  }

  void _showImageFullscreen(BuildContext context, int initialIndex) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            _ImageFullscreenView(
              imagePaths: imagePaths,
              initialIndex: initialIndex,
            ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 200),
        reverseTransitionDuration: const Duration(milliseconds: 200),
      ),
    );
  }
}

/// Fullscreen image viewer for journal images
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
