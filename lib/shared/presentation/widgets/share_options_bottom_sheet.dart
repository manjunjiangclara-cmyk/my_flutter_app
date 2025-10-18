import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/strings.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';

enum ShareOption { shareToApps, saveToPhotos }

class ShareOptionsBottomSheet extends StatelessWidget {
  const ShareOptionsBottomSheet({super.key});

  static Future<ShareOption?> show(BuildContext context) {
    return showModalBottomSheet<ShareOption>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(UIConstants.shareOptionsCornerRadius),
          topRight: Radius.circular(UIConstants.shareOptionsCornerRadius),
        ),
      ),
      builder: (context) {
        final height =
            MediaQuery.of(context).size.height * UIConstants.shareOptionsHeight;
        return SizedBox(height: height, child: const ShareOptionsBottomSheet());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: UIConstants.mediumPadding),
        Container(
          width: UIConstants.bottomSheetHandleWidth,
          height: UIConstants.bottomSheetHandleHeight,
          decoration: BoxDecoration(
            color: colorScheme.onSurface.withOpacity(0.2),
            borderRadius: BorderRadius.circular(
              UIConstants.bottomSheetHandleRadius,
            ),
          ),
        ),
        const SizedBox(height: UIConstants.mediumPadding),
        // // Padding(
        // //   padding: const EdgeInsets.symmetric(
        // //     horizontal: UIConstants.defaultPadding,
        // //   ),
        // //   child: Align(
        // //     alignment: Alignment.centerLeft,
        // //     child: Text(
        // //       AppStrings.shareOptionsTitle,
        // //       style: Theme.of(context).textTheme.labelLarge,
        // //     ),
        // //   ),
        // // ),
        // const SizedBox(height: UIConstants.mediumPadding),
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
        const SizedBox(height: UIConstants.largePadding),
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
