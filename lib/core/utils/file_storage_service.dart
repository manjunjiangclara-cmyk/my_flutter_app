import 'dart:developer' as developer;
import 'dart:io';
import 'dart:math';

import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

/// Service for managing local file storage operations
@injectable
class FileStorageService {
  static const String _imagesDirectory = 'journal_images';

  /// Get the app's documents directory
  Future<Directory> get _documentsDirectory async {
    final directory = await getApplicationDocumentsDirectory();
    return directory;
  }

  /// Get the images directory path
  Future<String> get _imagesDirectoryPath async {
    final documentsDir = await _documentsDirectory;
    return path.join(documentsDir.path, _imagesDirectory);
  }

  /// Ensure the images directory exists
  Future<Directory> _ensureImagesDirectory() async {
    final imagesPath = await _imagesDirectoryPath;
    final directory = Directory(imagesPath);

    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    return directory;
  }

  /// Generate a unique filename for an image
  String _generateUniqueFilename(String originalPath) {
    final extension = path.extension(originalPath);
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = Random().nextInt(10000);
    return 'image_${timestamp}_$random$extension';
  }

  /// Save an image file to local storage
  /// Returns the relative file path if successful, null otherwise
  Future<String?> saveImage(File imageFile) async {
    try {
      // Ensure the images directory exists
      final imagesDir = await _ensureImagesDirectory();

      // Generate a unique filename
      final filename = _generateUniqueFilename(imageFile.path);
      final localPath = path.join(imagesDir.path, filename);

      // Copy the file to the local storage
      final localFile = await imageFile.copy(localPath);

      // Convert to relative path for storage
      final documentsDir = await getApplicationDocumentsDirectory();
      final relativePath = path.relative(
        localFile.path,
        from: documentsDir.path,
      );

      // Debug: Log the saved path
      developer.log('✅ Image saved to: ${localFile.path}', name: 'FileStorage');
      developer.log('📁 Relative path: $relativePath', name: 'FileStorage');
      developer.log(
        '📁 Images directory: ${imagesDir.path}',
        name: 'FileStorage',
      );
      developer.log(
        '📄 File exists: ${await localFile.exists()}',
        name: 'FileStorage',
      );
      developer.log(
        '📏 File size: ${await localFile.length()} bytes',
        name: 'FileStorage',
      );

      return relativePath; // Return relative path instead of absolute
    } catch (e) {
      developer.log('❌ Error saving image: $e', name: 'FileStorage');
      return null;
    }
  }

  /// Save multiple images to local storage
  /// Returns a list of local file paths for successfully saved images
  Future<List<String>> saveImages(List<File> imageFiles) async {
    final List<String> savedPaths = [];

    for (final imageFile in imageFiles) {
      final savedPath = await saveImage(imageFile);
      if (savedPath != null) {
        savedPaths.add(savedPath);
      }
    }

    return savedPaths;
  }

  /// Check if a file exists at the given path
  Future<bool> fileExists(String filePath) async {
    try {
      final file = File(filePath);
      return await file.exists();
    } catch (e) {
      return false;
    }
  }

  /// Delete a file from local storage
  Future<bool> deleteFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      developer.log('Error deleting file: $e', name: 'FileStorage');
      return false;
    }
  }

  /// Delete multiple files from local storage
  Future<List<String>> deleteFiles(List<String> filePaths) async {
    final List<String> deletedPaths = [];

    for (final filePath in filePaths) {
      final deleted = await deleteFile(filePath);
      if (deleted) {
        deletedPaths.add(filePath);
      }
    }

    return deletedPaths;
  }

  /// Get file size in bytes
  Future<int> getFileSize(String filePath) async {
    try {
      final file = File(filePath);
      return await file.length();
    } catch (e) {
      return 0;
    }
  }

  /// Clean up orphaned files (files that are no longer referenced in the database)
  /// This is a utility method that can be called periodically
  Future<void> cleanupOrphanedFiles(List<String> referencedPaths) async {
    try {
      final imagesDir = await _ensureImagesDirectory();
      final files = await imagesDir.list().toList();

      for (final file in files) {
        if (file is File) {
          final filePath = file.path;
          if (!referencedPaths.contains(filePath)) {
            await file.delete();
          }
        }
      }
    } catch (e) {
      developer.log(
        'Error cleaning up orphaned files: $e',
        name: 'FileStorage',
      );
    }
  }
}
