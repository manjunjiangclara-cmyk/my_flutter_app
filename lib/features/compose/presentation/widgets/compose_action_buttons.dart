import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/spacings.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';

class ComposeActionButtons extends StatelessWidget {
  final VoidCallback onAddPhoto;
  final VoidCallback onAddLocation;
  final VoidCallback onAddTag;

  const ComposeActionButtons({
    super.key,
    required this.onAddPhoto,
    required this.onAddLocation,
    required this.onAddTag,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: UIConstants.defaultPadding,
        vertical: Spacing.md,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: Theme.of(
              context,
            ).colorScheme.outline.withValues(alpha: UIConstants.dialogOpacity),
            width: UIConstants.dialogBorderWidth,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            _buildActionButton(
              context,
              icon: Icons.image_outlined,
              onTap: onAddPhoto,
            ),
            const SizedBox(width: Spacing.lg),
            _buildActionButton(
              context,
              icon: Icons.location_on_outlined,
              onTap: onAddLocation,
            ),
            const SizedBox(width: Spacing.lg),
            _buildActionButton(
              context,
              icon: Icons.tag_outlined,
              onTap: onAddTag,
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(UIConstants.actionButtonPadding),
        decoration: BoxDecoration(
          color: Theme.of(
            context,
          ).colorScheme.outline.withValues(alpha: UIConstants.dialogOpacity),
          borderRadius: BorderRadius.circular(UIConstants.defaultRadius),
        ),
        child: Icon(icon, size: UIConstants.actionButtonIconSize),
      ),
    );
  }
}
