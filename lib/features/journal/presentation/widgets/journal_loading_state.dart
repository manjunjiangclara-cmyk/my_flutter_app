import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';

/// Loading state widget for journal view
class JournalLoadingState extends StatelessWidget {
  const JournalLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(height: UIConstants.mediumSpacing),
            Text('Loading journal...'),
          ],
        ),
      ),
    );
  }
}
