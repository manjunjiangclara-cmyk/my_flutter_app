import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
import 'package:my_flutter_app/core/utils/image_path_service.dart';

/// Utility class for common image widget operations
class ImageWidgetUtils {
  static final ImagePathService _imagePathService = ImagePathService();
  // Lightweight in-memory cache for image aspect ratios to stabilize layout
  static final Map<String, double> _pathToAspectRatio = {};

  static double? getCachedAspectRatio(String path) => _pathToAspectRatio[path];

  static void cacheAspectRatio(String path, double aspectRatio) {
    if (aspectRatio.isFinite && aspectRatio > 0) {
      _pathToAspectRatio[path] = aspectRatio;
    }
  }

  /// Converts image path to absolute path with loading state management
  static Future<String?> convertToAbsolutePath({
    required String imagePath,
    required Function(String?) onPathConverted,
  }) async {
    try {
      final absolutePath = await _imagePathService.getAbsolutePath(imagePath);
      onPathConverted(absolutePath);
      return absolutePath;
    } catch (e) {
      onPathConverted(null);
      return null;
    }
  }

  /// Builds a loading placeholder widget
  static Widget buildLoadingPlaceholder({
    required BuildContext context,
    required double height,
    required double width,
    Color? backgroundColor,
    Color? iconColor,
    double? iconSize,
  }) {
    return Container(
      height: height,
      width: width,
      color:
          backgroundColor ??
          Theme.of(context).colorScheme.outline.withOpacity(0.1),
      child: Center(
        child: Icon(
          Icons.image,
          size: iconSize ?? UIConstants.largeIconSize,
          color:
              iconColor ??
              Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.3),
        ),
      ),
    );
  }

  /// Builds an error placeholder widget
  static Widget buildErrorPlaceholder({
    required BuildContext context,
    required double height,
    required double width,
    Color? backgroundColor,
    Color? iconColor,
    double? iconSize,
  }) {
    return Container(
      height: height,
      width: width,
      color:
          backgroundColor ??
          Theme.of(context).colorScheme.outline.withOpacity(0.1),
      child: Center(
        child: Icon(
          Icons.broken_image_outlined,
          size: iconSize ?? UIConstants.largeIconSize,
          color:
              iconColor ??
              Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.6),
        ),
      ),
    );
  }
}
