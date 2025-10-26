import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/strings.dart';
import 'package:my_flutter_app/core/theme/fonts.dart';

class ComposeTextInput extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  const ComposeTextInput({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  @override
  State<ComposeTextInput> createState() => _ComposeTextInputState();
}

class _ComposeTextInputState extends State<ComposeTextInput> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      maxLines: null,
      // Optimize cursor rendering
      cursorColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
      cursorWidth: 2.0,
      // Improve text input performance
      textInputAction: TextInputAction.newline,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        hintText: AppStrings.composePrompt,
        hintStyle: AppTypography.bodyLarge.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero,
        // Remove unnecessary decorations for better performance
        isDense: true,
      ),
      style: AppTypography.bodyLarge,
      onChanged: widget.onChanged,
    );
  }
}
