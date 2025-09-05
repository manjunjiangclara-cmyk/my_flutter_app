import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/colors.dart';
import 'package:my_flutter_app/core/theme/fonts.dart';
import 'package:my_flutter_app/core/theme/spacings.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';

class ComposeScreen extends StatelessWidget {
  const ComposeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'August 28, 2025',
              style: AppTypography.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: Spacing.xl),
            Text(
              'Hey Anna, What is on your mind today?',
              style: AppTypography.headline2.copyWith(
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: Spacing.xxxl),
            CircleAvatar(
              radius: UIConstants.largeIconSize,
              backgroundColor: AppColors.border,
              child: Icon(
                Icons.add,
                size: UIConstants.largeIconSize,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
