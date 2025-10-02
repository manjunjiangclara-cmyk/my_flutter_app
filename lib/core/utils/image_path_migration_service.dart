import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

/// Service for handling image path migration when app container IDs change
@injectable
class ImagePathMigrationService {
  static const String _imagesDirectory = 'journal_images';

  /// Get the current app's documents directory
  Future<Directory> get _currentDocumentsDirectory async {
    return await getApplicationDocumentsDirectory();
  }

  /// Get the current images directory path
  Future<String> get _currentImagesDirectoryPath async {
    final documentsDir = await _currentDocumentsDirectory;
    return path.join(documentsDir.path, _imagesDirectory);
  }

  /// Check if an image path is valid (file exists)
  Future<bool> isImagePathValid(String imagePath) async {
    try {
      final file = File(imagePath);
      return await file.exists();
    } catch (e) {
      return false;
    }
  }

  /// Attempt to migrate an invalid image path to the current container
  /// Returns the new valid path if migration is successful, null otherwise
  Future<String?> migrateImagePath(String oldImagePath) async {
    try {
      // Extract the filename from the old path
      final filename = path.basename(oldImagePath);

      // Check if the file exists in the current images directory
      final currentImagesDir = await _currentImagesDirectoryPath;
      final newPath = path.join(currentImagesDir, filename);
      final newFile = File(newPath);

      if (await newFile.exists()) {
        print('✅ Image migrated: $oldImagePath -> $newPath');
        return newPath;
      }

      // If not found, try to find any file with the same name in the current directory
      final currentImagesDirObj = Directory(currentImagesDir);
      if (await currentImagesDirObj.exists()) {
        final files = await currentImagesDirObj.list().toList();
        for (final file in files) {
          if (file is File && path.basename(file.path) == filename) {
            print('✅ Image found in current directory: ${file.path}');
            return file.path;
          }
        }
      }

      print('❌ Image not found in current container: $filename');
      return null;
    } catch (e) {
      print('❌ Error migrating image path: $e');
      return null;
    }
  }

  /// Migrate a list of image paths
  /// Returns a list of valid paths (original if valid, migrated if successful, excluded if invalid)
  Future<List<String>> migrateImagePaths(List<String> imagePaths) async {
    final List<String> validPaths = [];

    for (final imagePath in imagePaths) {
      if (await isImagePathValid(imagePath)) {
        // Path is already valid
        validPaths.add(imagePath);
      } else {
        // Try to migrate the path
        final migratedPath = await migrateImagePath(imagePath);
        if (migratedPath != null) {
          validPaths.add(migratedPath);
        }
        // If migration fails, the path is excluded (image is lost)
      }
    }

    return validPaths;
  }

  /// Get all image files in the current images directory
  Future<List<String>> getCurrentImageFiles() async {
    try {
      final currentImagesDir = await _currentImagesDirectoryPath;
      final directory = Directory(currentImagesDir);

      if (!await directory.exists()) {
        return [];
      }

      final files = await directory.list().toList();
      return files.whereType<File>().map((file) => file.path).toList();
    } catch (e) {
      print('❌ Error getting current image files: $e');
      return [];
    }
  }

  /// Clean up orphaned image files (files not referenced in the database)
  Future<List<String>> cleanupOrphanedImages(
    List<String> referencedPaths,
  ) async {
    try {
      final currentImageFiles = await getCurrentImageFiles();
      final List<String> orphanedFiles = [];

      for (final filePath in currentImageFiles) {
        final filename = path.basename(filePath);
        final isReferenced = referencedPaths.any(
          (refPath) => path.basename(refPath) == filename,
        );

        if (!isReferenced) {
          try {
            await File(filePath).delete();
            orphanedFiles.add(filePath);
            print('🗑️ Deleted orphaned image: $filePath');
          } catch (e) {
            print('❌ Error deleting orphaned file $filePath: $e');
          }
        }
      }

      return orphanedFiles;
    } catch (e) {
      print('❌ Error cleaning up orphaned images: $e');
      return [];
    }
  }

  /// Validate and fix image paths for a journal
  /// Returns the updated image paths list
  Future<List<String>> validateAndFixJournalImagePaths(
    List<String> imagePaths,
  ) async {
    if (imagePaths.isEmpty) {
      return imagePaths;
    }

    print('🔍 Validating ${imagePaths.length} image paths...');

    final validPaths = await migrateImagePaths(imagePaths);

    if (validPaths.length != imagePaths.length) {
      final lostCount = imagePaths.length - validPaths.length;
      print('⚠️ Lost $lostCount images due to invalid paths');
    }

    return validPaths;
  }
}
