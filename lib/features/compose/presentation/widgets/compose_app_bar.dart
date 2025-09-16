import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/strings.dart';
import 'package:my_flutter_app/core/theme/fonts.dart';
import 'package:my_flutter_app/core/widgets/action_button.dart';

class ComposeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onPost;
  final bool canPost;

  const ComposeAppBar({super.key, required this.onPost, required this.canPost});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Text(
        AppStrings.sampleDate,
        style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold),
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
