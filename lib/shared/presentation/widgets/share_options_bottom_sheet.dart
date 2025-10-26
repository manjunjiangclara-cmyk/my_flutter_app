import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/strings.dart';
import 'package:my_flutter_app/core/theme/fonts.dart';
import 'package:my_flutter_app/core/theme/spacings.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
import 'package:my_flutter_app/shared/presentation/widgets/base_bottom_sheet.dart';

enum ShareOption { shareToApps, saveToPhotos }

class ShareOptionsBottomSheet extends StatelessWidget {
  const ShareOptionsBottomSheet({super.key});

  static Future<ShareOption?> show(BuildContext context) {
    return BaseBottomSheet.show<ShareOption>(
      context: context,
      height:
          MediaQuery.of(context).size.height * UIConstants.shareOptionsHeight,
      child: const ShareOptionsBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        _ShareOptionItem(
          icon: Icons.ios_share,
          label: AppStrings.shareToApps,
          onTap: () => Navigator.of(context).pop(ShareOption.shareToApps),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: UIConstants.smallPadding,
            vertical: UIConstants.extraSmallPadding,
          ),
          child: Divider(
            height: UIConstants.settingsSectionDividerHeight,
            thickness: UIConstants.settingsSectionDividerHeight,
            color: theme.colorScheme.outline.withOpacity(0.4),
          ),
        ),
        _ShareOptionItem(
          icon: Icons.photo_library_outlined,
          label: AppStrings.saveToPhotos,
          onTap: () => Navigator.of(context).pop(ShareOption.saveToPhotos),
        ),
      ],
    );
  }
}

class _ShareOptionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ShareOptionItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: theme.primaryColor.withOpacity(0.1),
        highlightColor: theme.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(UIConstants.defaultRadius),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: UIConstants.settingsTileHorizontalPadding,
            vertical: UIConstants.settingsTileVerticalPadding,
          ),
          child: Row(
            children: [
              // Leading icon
              SizedBox(
                width: 40,
                height: 40,
                child: Icon(
                  icon,
                  size: UIConstants.settingsTileIconSize,
                  color: theme.colorScheme.primary,
                ),
              ),

              const SizedBox(width: Spacing.md),

              // Title
              Expanded(child: Text(label, style: AppTypography.bodyLarge)),

              // Trailing chevron
              Icon(
                Icons.chevron_right,
                size: UIConstants.settingsTileTrailingIconSize,
                color: theme.colorScheme.onSurface.withOpacity(0.4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
