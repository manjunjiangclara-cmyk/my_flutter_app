import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/strings.dart';
import 'package:my_flutter_app/core/theme/fonts.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
import 'package:my_flutter_app/shared/presentation/widgets/base_bottom_sheet.dart';
import 'package:my_flutter_app/shared/presentation/widgets/section_divider.dart';
import 'package:my_flutter_app/shared/presentation/widgets/trailing_chevron.dart';

enum ShareOption { shareToApps, saveToPhotos }

class ShareOptionsBottomSheet extends StatelessWidget {
  const ShareOptionsBottomSheet({super.key});

  static Future<ShareOption?> show(BuildContext context) {
    return BaseBottomSheet.show<ShareOption>(
      context: context,
      title: AppStrings.shareOptionsTitle,
      height:
          MediaQuery.of(context).size.height * UIConstants.shareOptionsHeight,
      onClose: () => Navigator.of(context).pop(),
      closeButtonIconSize: UIConstants.datePickerCloseButtonIconSize,
      child: const ShareOptionsBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ShareOptionItem(
          icon: Icons.ios_share,
          label: AppStrings.shareToApps,
          onTap: () => Navigator.of(context).pop(ShareOption.shareToApps),
        ),
        const SectionDivider(),
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

              const SizedBox(width: UIConstants.mediumSpacing),

              // Title
              Expanded(child: Text(label, style: AppTypography.bodyLarge)),

              // Trailing chevron
              const TrailingChevron(),
            ],
          ),
        ),
      ),
    );
  }
}
