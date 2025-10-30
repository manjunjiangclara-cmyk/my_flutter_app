import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:my_flutter_app/core/theme/spacings.dart';

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
            SpinKitRing(color: Theme.of(context).colorScheme.onSurfaceVariant),
            SizedBox(height: Spacing.md),
            Text('Loading journal...'),
          ],
        ),
      ),
    );
  }
}
