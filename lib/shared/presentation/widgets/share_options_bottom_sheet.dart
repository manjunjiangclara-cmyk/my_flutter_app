import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/strings.dart';
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
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        _ShareOptionItem(
          icon: Icons.ios_share,
          label: AppStrings.shareToApps,
          onTap: () => Navigator.of(context).pop(ShareOption.shareToApps),
        ),
        Divider(
          height: 1,
          color: colorScheme.outline,
          indent: UIConstants.defaultPadding,
          endIndent: UIConstants.defaultPadding,
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
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: UIConstants.defaultPadding,
        vertical: UIConstants.smallPadding,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(UIConstants.defaultRadius),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(UIConstants.shareOptionItemPadding),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: UIConstants.shareOptionIconSize,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: UIConstants.mediumPadding),
                Text(
                  label,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontFamily: 'San Serif'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
