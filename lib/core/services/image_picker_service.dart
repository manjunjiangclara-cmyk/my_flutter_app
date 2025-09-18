import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
import 'package:permission_handler/permission_handler.dart';

/// Service for handling image selection from camera and gallery
@injectable
class ImagePickerService {
  static const int maxPhotos = UIConstants.maxPhotos;
  static const int maxImageSizeBytes = UIConstants.maxImageSizeBytes;

  final ImagePicker _imagePicker = ImagePicker();

  /// Pick a single image from camera or gallery
  Future<File?> pickImage({
    required ImageSource source,
    int? maxWidth,
    int? maxHeight,
    int? imageQuality,
  }) async {
    try {
      // Check permissions first
      final hasPermission = await _checkPermission(source);
      if (!hasPermission) {
        return null;
      }

      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: maxWidth?.toDouble(),
        maxHeight: maxHeight?.toDouble(),
        imageQuality: imageQuality,
      );

      if (image == null) return null;

      final file = File(image.path);

      // Validate file size
      if (!await _validateImageSize(file)) {
        return null;
      }

      return file;
    } catch (e) {
      return null;
    }
  }

  /// Pick multiple images from gallery
  Future<List<File>> pickMultipleImages({
    int? maxWidth,
    int? maxHeight,
    int? imageQuality,
  }) async {
    try {
      // Check gallery permission
      final hasPermission = await _checkPermission(ImageSource.gallery);
      if (!hasPermission) {
        return [];
      }

      final List<XFile> images = await _imagePicker.pickMultiImage(
        maxWidth: maxWidth?.toDouble(),
        maxHeight: maxHeight?.toDouble(),
        imageQuality: imageQuality,
      );

      if (images.isEmpty) return [];

      final List<File> validFiles = [];

      for (final image in images) {
        final file = File(image.path);
        if (await _validateImageSize(file)) {
          validFiles.add(file);
        }

        // Limit to max photos
        if (validFiles.length >= maxPhotos) break;
      }

      return validFiles;
    } catch (e) {
      return [];
    }
  }

  /// Check if we have permission for gallery access
  Future<bool> _checkPermission(ImageSource source) async {
    // For gallery access, check multiple permission types for better compatibility
    final photosStatus = await Permission.photos.status;
    final storageStatus = await Permission.storage.status;

    // If either permission is granted, we're good
    if (photosStatus.isGranted || storageStatus.isGranted) {
      return true;
    }

    // If permissions are denied, request them
    if (photosStatus.isDenied || storageStatus.isDenied) {
      // Request both permissions
      final results = await [Permission.photos, Permission.storage].request();

      final photosResult = results[Permission.photos];
      final storageResult = results[Permission.storage];

      return photosResult?.isGranted == true ||
          storageResult?.isGranted == true;
    }

    return false;
  }

  /// Validate image file size
  Future<bool> _validateImageSize(File file) async {
    try {
      final fileSize = await file.length();
      return fileSize <= maxImageSizeBytes;
    } catch (e) {
      return false;
    }
  }

  /// Get permission status for photos
  Future<PermissionStatus> getPhotosPermissionStatus() async {
    return await Permission.photos.status;
  }

  /// Check if we can add more photos (respecting the limit)
  bool canAddMorePhotos(int currentCount) {
    return currentCount < maxPhotos;
  }

  /// Get remaining photo slots
  int getRemainingPhotoSlots(int currentCount) {
    return maxPhotos - currentCount;
  }
}
