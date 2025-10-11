import 'package:flutter/material.dart';
import 'package:my_flutter_app/shared/presentation/widgets/action_button.dart';

/// Example demonstrating how to use ActionButton with both regular icons and SVG icons
class ActionButtonExample extends StatelessWidget {
  const ActionButtonExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ActionButton Examples'),
        actions: [
          // Using regular Material icon
          ActionButton(
            icon: Icons.star,
            onPressed: () => print('Star pressed'),
            tooltip: 'Star',
          ),
          // Using SVG icon
          ActionButton(
            svgAssetPath: 'assets/icons/custom_star.svg',
            onPressed: () => print('Custom star pressed'),
            tooltip: 'Custom Star SVG',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Regular Icon Buttons:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ActionButton(
                  icon: Icons.favorite,
                  onPressed: () => print('Heart pressed'),
                  tooltip: 'Heart',
                ),
                const SizedBox(width: 16),
                ActionButton(
                  icon: Icons.share,
                  onPressed: () => print('Share pressed'),
                  tooltip: 'Share',
                ),
                const SizedBox(width: 16),
                ActionButton(
                  icon: Icons.edit,
                  onPressed: () => print('Edit pressed'),
                  tooltip: 'Edit',
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              'SVG Icon Buttons:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ActionButton(
                  svgAssetPath: 'assets/icons/custom_heart.svg',
                  onPressed: () => print('Custom heart pressed'),
                  tooltip: 'Custom Heart SVG',
                ),
                const SizedBox(width: 16),
                ActionButton(
                  svgAssetPath: 'assets/icons/custom_star.svg',
                  onPressed: () => print('Custom star pressed'),
                  tooltip: 'Custom Star SVG',
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              'Filled Style Buttons:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ActionButton.filled(
                  icon: Icons.save,
                  onPressed: () => print('Save pressed'),
                  tooltip: 'Save',
                ),
                const SizedBox(width: 16),
                ActionButton.filled(
                  svgAssetPath: 'assets/icons/custom_star.svg',
                  onPressed: () => print('Custom star filled pressed'),
                  tooltip: 'Custom Star Filled',
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              'Disabled Buttons:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ActionButton(
                  icon: Icons.star,
                  onPressed: null, // Disabled
                  tooltip: 'Disabled Star',
                ),
                const SizedBox(width: 16),
                ActionButton(
                  svgAssetPath: 'assets/icons/custom_heart.svg',
                  onPressed: null, // Disabled
                  tooltip: 'Disabled Custom Heart',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
