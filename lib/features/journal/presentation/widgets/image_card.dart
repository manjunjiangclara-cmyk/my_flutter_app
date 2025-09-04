import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/colors.dart';
import 'package:my_flutter_app/core/ui_constants.dart';

class ImageCard extends StatelessWidget {
  final String imageUrl;
  final double imageHeight;

  const ImageCard({super.key, required this.imageUrl, this.imageHeight = 150});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(UIConstants.defaultCardRadius),
      child: Image.network(
        imageUrl,
        height: imageHeight,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder:
            (BuildContext context, Object error, StackTrace? stackTrace) =>
                Container(
                  height: imageHeight,
                  color: AppColors.border,
                  child: Center(
                    child: Icon(
                      Icons.broken_image,
                      size: UIConstants.largeIconSize,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
      ),
    );
  }
}
