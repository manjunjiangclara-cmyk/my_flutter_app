import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/spacings.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
import 'package:my_flutter_app/shared/presentation/widgets/round_icon_button.dart';

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
            RoundIconButton(
              icon: Icons.image_outlined,
              onPressed: onAddPhoto,
              tooltip: 'Add Photo',
              diameter: UIConstants.actionButtonDiameter,
              borderWidth: UIConstants.actionButtonBorderWidth,
            ),
            const SizedBox(width: Spacing.lg),
            RoundIconButton(
              icon: Icons.location_on_outlined,
              onPressed: onAddLocation,
              tooltip: 'Add Location',
              diameter: UIConstants.actionButtonDiameter,
              borderWidth: UIConstants.actionButtonBorderWidth,
            ),
            const SizedBox(width: Spacing.lg),
            RoundIconButton(
              icon: Icons.tag_outlined,
              onPressed: onAddTag,
              tooltip: 'Add Tag',
              diameter: UIConstants.actionButtonDiameter,
              borderWidth: UIConstants.actionButtonBorderWidth,
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
