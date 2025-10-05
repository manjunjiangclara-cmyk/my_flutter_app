import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

/// Service for handling image path conversions
@injectable
class ImagePathService {
  String? _cachedDocumentsDirPath;

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

      // Convert relative path to absolute
      final documentsPath = await getDocumentsDirectoryPath();
      return path.join(documentsPath, imagePath);
    } catch (e) {
      print('❌ Error converting image path: $e');
      return imagePath; // Return original path as fallback
    }
  }

  /// Convert multiple relative paths to absolute paths
  Future<Map<String, String>> getAbsolutePaths(List<String> imagePaths) async {
    final Map<String, String> absolutePaths = {};

    try {
      // Resolve documents directory once to avoid many platform calls
      final documentsPath = await getDocumentsDirectoryPath();

      for (final imagePath in imagePaths) {
        if (path.isAbsolute(imagePath)) {
          absolutePaths[imagePath] = imagePath;
        } else {
          absolutePaths[imagePath] = path.join(documentsPath, imagePath);
        }
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
}
