import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
import 'package:my_flutter_app/features/journal/presentation/widgets/image_card.dart';

/// Image gallery widget for displaying all journal images
class JournalImageGallery extends StatelessWidget {
  final List<String> imagePaths;

  const JournalImageGallery({super.key, required this.imagePaths});

  @override
  Widget build(BuildContext context) {
    if (imagePaths.length <= 1) {
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
      child: Hero(
        tag: 'journal_image_$index',
        child: ImageCard(
          imageUrl: imagePath,
          imageHeight: UIConstants.journalImageGalleryItemHeight,
        ),
      ),
    );
  }

  void _showImageFullscreen(BuildContext context, int initialIndex) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _ImageFullscreenView(
          imagePaths: imagePaths,
          initialIndex: initialIndex,
        ),
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          '${_currentIndex + 1} / ${widget.imagePaths.length}',
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemCount: widget.imagePaths.length,
        itemBuilder: (context, index) {
          return Center(
            child: Hero(
              tag: 'journal_image_$index',
              child: ImageCard(
                imageUrl: widget.imagePaths[index],
                imageHeight: MediaQuery.of(context).size.height * 0.7,
              ),
            ),
          );
        },
      ),
    );
  }
}
