import 'dart:developer' as developer;

import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

/// Service for handling image path conversions
@injectable
class ImagePathService {
  String? _cachedDocumentsDirPath;
  final Map<String, String> _pathCache = {};

  /// Prewarm and cache the documents directory path to avoid repeated platform calls
  Future<void> prewarmDocumentsDirectory() async {
    try {
      if (_cachedDocumentsDirPath == null) {
        final documentsDir = await getApplicationDocumentsDirectory();
        _cachedDocumentsDirPath = documentsDir.path;
      }
    } catch (_) {
      // Ignore prewarm failures; fallback path resolution will still work
    }
  }

  /// Convert relative path to absolute path for display
  Future<String> getAbsolutePath(String imagePath) async {
    try {
      // If already absolute, return as is
      if (path.isAbsolute(imagePath)) {
        return imagePath;
      }

      // Check cache first
      if (_pathCache.containsKey(imagePath)) {
        return _pathCache[imagePath]!;
      }

      // Convert relative path to absolute
      final documentsPath = await getDocumentsDirectoryPath();
      final absolutePath = path.join(documentsPath, imagePath);

      // Cache the result
      _pathCache[imagePath] = absolutePath;

      return absolutePath;
    } catch (e) {
      developer.log(
        '❌ Error converting image path: $e',
        name: 'ImagePathService',
      );
      return imagePath; // Return original path as fallback
    }
  }

  /// Convert multiple relative paths to absolute paths
  Future<Map<String, String>> getAbsolutePaths(List<String> imagePaths) async {
    final Map<String, String> absolutePaths = {};

    try {
      // Batch process paths for better performance
      final documentsPath = await getDocumentsDirectoryPath();

      for (final imagePath in imagePaths) {
        // Check cache first
        if (_pathCache.containsKey(imagePath)) {
          absolutePaths[imagePath] = _pathCache[imagePath]!;
          continue;
        }

        // If already absolute, return as is
        if (path.isAbsolute(imagePath)) {
          absolutePaths[imagePath] = imagePath;
          _pathCache[imagePath] = imagePath;
          continue;
        }

        // Convert relative path to absolute
        final absolutePath = path.join(documentsPath, imagePath);
        absolutePaths[imagePath] = absolutePath;
        _pathCache[imagePath] = absolutePath;
      }

      return absolutePaths;
    } catch (e) {
      // Fallback: best-effort per item
      for (final imagePath in imagePaths) {
        try {
          final absolutePath = await getAbsolutePath(imagePath);
          absolutePaths[imagePath] = absolutePath;
        } catch (_) {
          absolutePaths[imagePath] = imagePath;
        }
      }
      return absolutePaths;
    }
  }

  /// Check if a path is relative
  bool isRelativePath(String imagePath) {
    return !path.isAbsolute(imagePath);
  }

  /// Get the documents directory path
  Future<String> getDocumentsDirectoryPath() async {
    if (_cachedDocumentsDirPath != null) {
      return _cachedDocumentsDirPath!;
    }
    final documentsDir = await getApplicationDocumentsDirectory();
    _cachedDocumentsDirPath = documentsDir.path;
    return _cachedDocumentsDirPath!;
  }

  /// Clear the path cache (useful for testing or when paths might change)
  void clearCache() {
    _pathCache.clear();
  }

  /// Get cache size for monitoring
  int getCacheSize() {
    return _pathCache.length;
  }

  /// Preload common paths into cache
  Future<void> preloadPaths(List<String> imagePaths) async {
    for (final path in imagePaths) {
      await getAbsolutePath(path);
    }
  }
}
