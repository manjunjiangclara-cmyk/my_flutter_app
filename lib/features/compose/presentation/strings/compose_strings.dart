import 'package:my_flutter_app/core/utils/date_formatter.dart';

/// Compose feature-specific strings
class ComposeStrings {
  ComposeStrings._();

  // ---------- UI Text ----------
  static const String composePrompt = 'Hey, What is on your mind today?';
  static const String post = 'Post';
  static const String addLocation = 'Add Location';
  static const String addTag = 'Add Tag';
  static const String addPhoto = 'Add Photo';
  static const String addMorePhotos = 'Add More Photos';

  // ---------- Hints ----------
  static const String searchLocationHint = 'Search for a location...';
  static const String enterTagHint = 'Enter a tag...';

  // ---------- Messages ----------
  static const String memoryLodgedSuccessfully =
      'Your memory has been safely lodged ❤️';
  static const String postingMemory = 'Posting your memory...';
  static const String postFailed = 'Failed to post your memory';
  static const String photoLimitReached = 'Maximum 9 photos allowed';
  static const String permissionDenied =
      'Permission denied. Please enable camera and gallery access in settings.';
  static const String imageTooLarge =
      'Image is too large. Please choose a smaller image.';
  static const String failedToLoadImage = 'Failed to load image';

  // ---------- Sample Data ----------
  static String get sampleDate => DateFormatter.getTodayFormatted();
}
