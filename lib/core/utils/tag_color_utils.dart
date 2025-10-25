import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/colors.dart';

/// Utility class for managing tag colors
class TagColorUtils {
  TagColorUtils._();

  /// Gets a consistent color for a tag based on its name hash
  /// This ensures the same tag always gets the same color
  static Color getTagColor(String tagName) {
    // Use the tag name hash to get a consistent index
    final hash = tagName.hashCode;
    final index = hash.abs() % AppColors.tagColors.length;
    return AppColors.tagColors[index];
  }

  /// Gets a list of colors for multiple tags
  static List<Color> getTagColors(List<String> tagNames) {
    return tagNames.map(getTagColor).toList();
  }

  /// Gets a map of tag names to their assigned colors
  static Map<String, Color> getTagColorMap(List<String> tagNames) {
    final Map<String, Color> colorMap = {};
    for (final tag in tagNames) {
      colorMap[tag] = getTagColor(tag);
    }
    return colorMap;
  }
}
