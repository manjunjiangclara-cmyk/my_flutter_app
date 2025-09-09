import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/strings.dart';
import 'package:my_flutter_app/core/theme/colors.dart';
import 'package:my_flutter_app/core/theme/fonts.dart';
import 'package:my_flutter_app/core/theme/spacings.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';

class ComposeScreen extends StatefulWidget {
  const ComposeScreen({super.key});

  @override
  State<ComposeScreen> createState() => _ComposeScreenState();
}

class _ComposeScreenState extends State<ComposeScreen> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  final FocusNode _textFocusNode = FocusNode();
  final FocusNode _locationFocusNode = FocusNode();
  final FocusNode _tagFocusNode = FocusNode();

  final List<String> _attachedPhotos = [];
  final List<String> _selectedTags = [];
  String? _selectedLocation;

  @override
  void dispose() {
    _textController.dispose();
    _locationController.dispose();
    _tagController.dispose();
    _textFocusNode.dispose();
    _locationFocusNode.dispose();
    _tagFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(UIConstants.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // _buildUserProfile(),
                  // const SizedBox(height: Spacing.lg),
                  _buildTextInput(),
                  const SizedBox(height: Spacing.lg),
                  if (_attachedPhotos.isNotEmpty) _buildPhotoAttachments(),
                  if (_attachedPhotos.isNotEmpty)
                    const SizedBox(height: Spacing.lg),
                  if (_selectedLocation != null) _buildLocationDisplay(),
                  if (_selectedLocation != null)
                    const SizedBox(height: Spacing.lg),
                  if (_selectedTags.isNotEmpty) _buildTagsDisplay(),
                  if (_selectedTags.isNotEmpty)
                    const SizedBox(height: Spacing.lg),
                  // Add extra padding when keyboard is visible
                  if (keyboardHeight > 0) SizedBox(height: keyboardHeight),
                ],
              ),
            ),
          ),
          _buildActionButtons(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        "September 8, 2025",
        style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold),
      ),
      actions: [
        TextButton(
          onPressed: _canPost() ? _handlePost : null,
          child: Text(
            'Post',
            style: AppTypography.labelLarge.copyWith(
              color: _canPost()
                  ? Theme.of(context).colorScheme.primary
                  : AppColors.textSecondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  // Widget _buildUserProfile() {
  //   return Row(
  //     children: [
  //       CircleAvatar(
  //         radius: 20,
  //         backgroundColor: AppColors.border,
  //         child: const Icon(Icons.person, color: AppColors.textSecondary),
  //       ),
  //       const SizedBox(width: Spacing.md),
  //       Expanded(
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(
  //               'You',
  //               style: AppTypography.labelLarge.copyWith(
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //             Text(
  //               AppStrings.sampleDate,
  //               style: AppTypography.labelSmall.copyWith(
  //                 color: AppColors.textSecondary,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildTextInput() {
    return TextField(
      controller: _textController,
      focusNode: _textFocusNode,
      maxLines: null,
      decoration: InputDecoration(
        hintText: AppStrings.composePrompt,
        hintStyle: AppTypography.bodyLarge.copyWith(
          color: AppColors.textSecondary,
        ),
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero,
      ),
      style: AppTypography.bodyLarge,
      onChanged: (value) => setState(() {}),
    );
  }

  Widget _buildPhotoAttachments() {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _attachedPhotos.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(right: Spacing.sm),
            child: Stack(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      UIConstants.defaultRadius,
                    ),
                    color: AppColors.border,
                  ),
                  child: const Icon(
                    Icons.image,
                    color: AppColors.textSecondary,
                    size: 40,
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () => _removePhoto(index),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLocationDisplay() {
    return Container(
      padding: const EdgeInsets.all(Spacing.sm),
      decoration: BoxDecoration(
        color: AppColors.border.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(UIConstants.defaultRadius),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.location_on,
            size: 16,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: Spacing.xs),
          Expanded(
            child: Text(_selectedLocation!, style: AppTypography.labelMedium),
          ),
          GestureDetector(
            onTap: _removeLocation,
            child: const Icon(
              Icons.close,
              size: 16,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagsDisplay() {
    return Wrap(
      spacing: Spacing.sm,
      runSpacing: Spacing.xs,
      children: _selectedTags.map((tag) => _buildTagChip(tag)).toList(),
    );
  }

  Widget _buildTagChip(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.sm,
        vertical: Spacing.xs,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(UIConstants.defaultRadius),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '#$tag',
            style: AppTypography.labelSmall.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () => _removeTag(tag),
            child: Icon(
              Icons.close,
              size: 14,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: UIConstants.defaultPadding,
        vertical: Spacing.md,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: AppColors.border.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            _buildActionButton(icon: Icons.image_outlined, onTap: _addPhoto),
            const SizedBox(width: Spacing.lg),
            _buildActionButton(
              icon: Icons.location_on_outlined,
              onTap: _addLocation,
            ),
            const SizedBox(width: Spacing.lg),
            _buildActionButton(icon: Icons.tag_outlined, onTap: _addTag),
            const Spacer(),
            // Add a subtle indicator that these are action buttons
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(Spacing.md),
        decoration: BoxDecoration(
          color: AppColors.border.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(UIConstants.defaultRadius),
        ),
        child: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: 24,
        ),
      ),
    );
  }

  bool _canPost() {
    return _textController.text.trim().isNotEmpty ||
        _attachedPhotos.isNotEmpty ||
        _selectedLocation != null ||
        _selectedTags.isNotEmpty;
  }

  void _handlePost() {
    if (!_canPost()) return;

    // Simulate posting
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Posted successfully!')));
      }
    });
  }

  void _addPhoto() {
    // Simulate adding a photo
    setState(() {
      _attachedPhotos.add('photo_${_attachedPhotos.length + 1}');
    });
  }

  void _removePhoto(int index) {
    setState(() {
      _attachedPhotos.removeAt(index);
    });
  }

  void _addLocation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Location'),
        content: TextField(
          controller: _locationController,
          focusNode: _locationFocusNode,
          decoration: const InputDecoration(
            hintText: 'Search for a location...',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (value) {
            if (value.trim().isNotEmpty) {
              setState(() {
                _selectedLocation = value.trim();
              });
              Navigator.of(context).pop();
              _locationController.clear();
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (_locationController.text.trim().isNotEmpty) {
                setState(() {
                  _selectedLocation = _locationController.text.trim();
                });
                Navigator.of(context).pop();
                _locationController.clear();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _removeLocation() {
    setState(() {
      _selectedLocation = null;
    });
  }

  void _addTag() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Tag'),
        content: TextField(
          controller: _tagController,
          focusNode: _tagFocusNode,
          decoration: const InputDecoration(
            hintText: 'Enter a tag...',
            border: OutlineInputBorder(),
            prefixText: '#',
          ),
          onSubmitted: (value) {
            if (value.trim().isNotEmpty &&
                !_selectedTags.contains(value.trim())) {
              setState(() {
                _selectedTags.add(value.trim());
              });
              Navigator.of(context).pop();
              _tagController.clear();
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (_tagController.text.trim().isNotEmpty &&
                  !_selectedTags.contains(_tagController.text.trim())) {
                setState(() {
                  _selectedTags.add(_tagController.text.trim());
                });
                Navigator.of(context).pop();
                _tagController.clear();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _removeTag(String tag) {
    setState(() {
      _selectedTags.remove(tag);
    });
  }
}
