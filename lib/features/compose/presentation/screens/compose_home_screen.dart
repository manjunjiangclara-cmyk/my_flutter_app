import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_flutter_app/core/di/injection.dart';
import 'package:my_flutter_app/core/strings.dart';
import 'package:my_flutter_app/core/theme/fonts.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
import 'package:my_flutter_app/features/compose/presentation/bloc/compose_bloc.dart';
import 'package:my_flutter_app/features/compose/presentation/screens/compose_screen.dart';

class ComposeHomeScreen extends StatelessWidget {
  const ComposeHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(UIConstants.defaultPadding),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppStrings.sampleDate,
                style: AppTypography.labelSmall.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: UIConstants.largeSpacing),
              Text(
                AppStrings.composePrompt,
                style: AppTypography.displayLarge.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: UIConstants.largePadding),
              GestureDetector(
                onTap: () => _navigateToCompose(context),
                child: CircleAvatar(
                  radius: UIConstants.largeIconSize,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Icon(
                    Icons.add,
                    size: UIConstants.largeIconSize,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToCompose(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (_) => getIt<ComposeBloc>(),
          child: const ComposeScreen(),
        ),
      ),
    );
  }
}
