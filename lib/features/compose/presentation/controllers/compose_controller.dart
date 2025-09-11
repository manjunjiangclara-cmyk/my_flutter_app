import 'package:flutter/material.dart';

/// Controller for managing compose screen state and business logic
class ComposeController extends ChangeNotifier {
  final TextEditingController textController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController tagController = TextEditingController();

  final FocusNode textFocusNode = FocusNode();
  final FocusNode locationFocusNode = FocusNode();
  final FocusNode tagFocusNode = FocusNode();

  final List<String> _attachedPhotos = [];
  final List<String> _selectedTags = [];
  String? _selectedLocation;

  // Getters
  List<String> get attachedPhotos => List.unmodifiable(_attachedPhotos);
  List<String> get selectedTags => List.unmodifiable(_selectedTags);
  String? get selectedLocation => _selectedLocation;

  bool get canPost =>
      textController.text.trim().isNotEmpty ||
      _attachedPhotos.isNotEmpty ||
      _selectedLocation != null ||
      _selectedTags.isNotEmpty;

  @override
  void dispose() {
    textController.dispose();
    locationController.dispose();
    tagController.dispose();
    textFocusNode.dispose();
    locationFocusNode.dispose();
    tagFocusNode.dispose();
    super.dispose();
  }

  // Photo management
  void addPhoto() {
    _attachedPhotos.add('photo_${_attachedPhotos.length + 1}');
    notifyListeners();
  }

  void removePhoto(int index) {
    if (index >= 0 && index < _attachedPhotos.length) {
      _attachedPhotos.removeAt(index);
      notifyListeners();
    }
  }

  // Location management
  void addLocation(String location) {
    if (location.trim().isNotEmpty) {
      _selectedLocation = location.trim();
      locationController.clear();
      notifyListeners();
    }
  }

  void removeLocation() {
    _selectedLocation = null;
    notifyListeners();
  }

  // Tag management
  void addTag(String tag) {
    final trimmedTag = tag.trim();
    if (trimmedTag.isNotEmpty && !_selectedTags.contains(trimmedTag)) {
      _selectedTags.add(trimmedTag);
      tagController.clear();
      notifyListeners();
    }
  }

  void removeTag(String tag) {
    _selectedTags.remove(tag);
    notifyListeners();
  }

  // Text change handler
  void onTextChanged() {
    notifyListeners();
  }

  // Post handling
  Future<void> handlePost(BuildContext context) async {
    if (!canPost) return;

    // Simulate posting
    await Future.delayed(const Duration(seconds: 1));

    if (context.mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Posted successfully!')));
    }
  }
}
