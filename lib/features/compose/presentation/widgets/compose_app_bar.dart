import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/strings.dart';
import 'package:my_flutter_app/core/theme/fonts.dart';

class ComposeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onPost;
  final bool canPost;

  const ComposeAppBar({super.key, required this.onPost, required this.canPost});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        AppStrings.sampleDate,
        style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold),
      ),
      actions: [
        TextButton(
          onPressed: canPost ? onPost : null,
          child: Text(
            AppStrings.post,
            style: AppTypography.labelLarge.copyWith(
              color: canPost
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.38),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
