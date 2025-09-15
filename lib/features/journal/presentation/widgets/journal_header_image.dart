import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
import 'package:my_flutter_app/features/journal/presentation/strings/journal_strings.dart';

/// Header image widget for journal view
class JournalHeaderImage extends StatelessWidget {
  final List<String> imageUrls;

  const JournalHeaderImage({super.key, required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: UIConstants.journalHeaderImageHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.outline,
        borderRadius: BorderRadius.circular(UIConstants.defaultRadius),
      ),
      child: imageUrls.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(UIConstants.defaultRadius),
              child: Image.network(
                imageUrls.first,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _buildPlaceholder(context),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return _buildLoadingPlaceholder(context);
                },
              ),
            )
          : _buildPlaceholder(context),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Center(
      child: Icon(
        Icons.image,
        size: UIConstants.largeIconSize,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        semanticLabel: JournalStrings.journalImageLabel,
      ),
    );
  }

  Widget _buildLoadingPlaceholder(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: UIConstants.smallPadding),
          Text(
            'Loading image...',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
