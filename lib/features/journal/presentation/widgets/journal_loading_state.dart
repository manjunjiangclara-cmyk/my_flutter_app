import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/spacings.dart';

/// Loading state widget for journal view
class JournalLoadingState extends StatelessWidget {
  const JournalLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: Spacing.md),
            Text('Loading journal...'),
          ],
        ),
      ),
    );
  }
}
