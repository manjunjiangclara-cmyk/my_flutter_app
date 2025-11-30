import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
import 'package:my_flutter_app/features/journal/presentation/strings/journal_strings.dart';

/// Error state widget for journal view
class JournalErrorState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const JournalErrorState({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(UIConstants.defaultPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: UIConstants.mediumSpacing),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: UIConstants.defaultPadding),
              ElevatedButton(
                onPressed: onRetry ?? () => _retry(context),
                child: const Text(JournalStrings.retry),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _retry(BuildContext context) {
    // This will be handled by the parent widget
    // The parent should provide the retry callback
  }
}
