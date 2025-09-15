import 'package:flutter/material.dart';

class ColorDebugWidget extends StatelessWidget {
  const ColorDebugWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ColorScheme Debug',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildColorRow('Primary', colorScheme.primary),
            _buildColorRow('Secondary', colorScheme.secondary),
            _buildColorRow('Surface', colorScheme.surface),
            _buildColorRow('Background', colorScheme.surface),
            _buildColorRow('Outline', colorScheme.outline),
            _buildColorRow('OnSurface (Text)', colorScheme.onSurface),
            _buildColorRow('OnPrimary', colorScheme.onPrimary),
            _buildColorRow('OnSecondary', colorScheme.onSecondary),
            _buildColorRow('OnSurfaceVariant', colorScheme.onSurfaceVariant),
            _buildColorRow('Error', colorScheme.error),
            _buildColorRow('OnError', colorScheme.onError),
            const SizedBox(height: 16),
            const Text(
              'Text Samples:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'This is primary text',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              'This is secondary text',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              'This is label text',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorRow(String name, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color,
              border: Border.all(color: Colors.grey),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text('$name: ${color.toString()}')),
        ],
      ),
    );
  }
}
