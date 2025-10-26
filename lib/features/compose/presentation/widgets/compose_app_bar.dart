import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/fonts.dart';
import 'package:my_flutter_app/shared/presentation/widgets/action_button.dart';

class ComposeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onPost;
  final bool canPost;
  final String dateText;
  final VoidCallback? onTapDate;

  const ComposeAppBar({
    super.key,
    required this.onPost,
    required this.canPost,
    required this.dateText,
    this.onTapDate,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: GestureDetector(
        onTap: onTapDate,
        child: Text(
          dateText,
          style: AppTypography.bodyLarge.copyWith(
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
      actions: [
        ActionButton(
          icon: Icons.save_alt_outlined,
          onPressed: canPost ? onPost : null,
          enabled: canPost,
          tooltip: 'Save',
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
