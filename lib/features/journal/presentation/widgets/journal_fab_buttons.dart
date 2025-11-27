import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
import 'package:my_flutter_app/features/journal/presentation/strings/journal_strings.dart';
import 'package:my_flutter_app/shared/presentation/widgets/action_button.dart';

class JournalFabButtons extends StatefulWidget {
  final bool isVisible;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onShareTap;

  const JournalFabButtons({
    super.key,
    required this.isVisible,
    required this.onEdit,
    required this.onDelete,
    required this.onShareTap,
  });

  @override
  State<JournalFabButtons> createState() => _JournalFabButtonsState();
}

class _JournalFabButtonsState extends State<JournalFabButtons> {
  Offset _position = Offset.zero;
  final GlobalKey _fabKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // Initialize position to right side center
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final size = MediaQuery.of(context).size;
        final safeArea = MediaQuery.of(context).padding;
        final buttonSize = UIConstants.journalAppBarOverlayButtonDiameter;
        final spacing = UIConstants.journalAppBarOverlayButtonSpacing;
        final totalHeight = (buttonSize * 3) + (spacing * 2);

        setState(() {
          _position = Offset(
            size.width -
                safeArea.right -
                UIConstants.defaultPadding -
                buttonSize,
            (size.height - safeArea.top - safeArea.bottom - totalHeight) / 2 +
                safeArea.top,
          );
        });
      }
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _position += details.delta;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    // Snap to nearest edge
    _snapToEdge();
  }

  void _snapToEdge() {
    final size = MediaQuery.of(context).size;
    final safeArea = MediaQuery.of(context).padding;
    final buttonSize = UIConstants.journalAppBarOverlayButtonDiameter;
    final spacing = UIConstants.journalAppBarOverlayButtonSpacing;
    final totalHeight = (buttonSize * 3) + (spacing * 2);

    double newX = _position.dx;
    double newY = _position.dy;

    // Snap to left or right edge
    if (_position.dx < size.width / 2) {
      newX = safeArea.left + UIConstants.defaultPadding;
    } else {
      newX =
          size.width - safeArea.right - UIConstants.defaultPadding - buttonSize;
    }

    // Keep within vertical bounds
    final maxY =
        size.height -
        safeArea.bottom -
        totalHeight -
        UIConstants.defaultPadding;
    final minY = safeArea.top + UIConstants.defaultPadding;
    newY = newY.clamp(minY, maxY);

    setState(() {
      _position = Offset(newX, newY);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_position == Offset.zero) {
      // Return empty widget until position is initialized
      return const SizedBox.shrink();
    }

    final size = MediaQuery.of(context).size;
    final safeArea = MediaQuery.of(context).padding;
    final buttonSize = UIConstants.journalAppBarOverlayButtonDiameter;
    final spacing = UIConstants.journalAppBarOverlayButtonSpacing;
    final totalHeight = (buttonSize * 3) + (spacing * 2);

    // Ensure position stays within bounds
    double x = _position.dx.clamp(
      safeArea.left + UIConstants.defaultPadding,
      size.width - safeArea.right - UIConstants.defaultPadding - buttonSize,
    );
    double y = _position.dy.clamp(
      safeArea.top + UIConstants.defaultPadding,
      size.height - safeArea.bottom - totalHeight - UIConstants.defaultPadding,
    );

    return Positioned(
      left: x,
      top: y,
      child: IgnorePointer(
        ignoring: !widget.isVisible,
        child: AnimatedOpacity(
          opacity: widget.isVisible ? 1.0 : 0.0,
          duration: UIConstants.defaultAnimation,
          curve: Curves.easeOut,
          child: GestureDetector(
            onPanUpdate: _onPanUpdate,
            onPanEnd: _onPanEnd,
            child: Container(
              key: _fabKey,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(buttonSize / 2),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildButton(
                    context,
                    svgAssetPath: 'assets/icons/edit.svg',
                    onPressed: widget.onEdit,
                    tooltip: JournalStrings.editJournal,
                  ),
                  SizedBox(
                    height: UIConstants.journalAppBarOverlayButtonSpacing,
                  ),
                  _buildButton(
                    context,
                    svgAssetPath: 'assets/icons/share.svg',
                    onPressed: widget.onShareTap,
                    tooltip: JournalStrings.shareJournal,
                  ),
                  SizedBox(
                    height: UIConstants.journalAppBarOverlayButtonSpacing,
                  ),
                  _buildButton(
                    context,
                    svgAssetPath: 'assets/icons/delete.svg',
                    onPressed: widget.onDelete,
                    tooltip: JournalStrings.deleteJournal,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(
    BuildContext context, {
    required String svgAssetPath,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withValues(
              alpha: UIConstants.journalAppBarActionShadowOpacity,
            ),
            blurRadius: UIConstants.journalAppBarActionShadowBlur,
            offset: const Offset(
              0,
              UIConstants.journalAppBarActionShadowOffsetY,
            ),
          ),
        ],
      ),
      child: ActionButton.circular(
        svgAssetPath: svgAssetPath,
        onPressed: onPressed,
        tooltip: tooltip,
        iconSize: UIConstants.actionButtonIconSize,
        padding: EdgeInsets.all(
          (UIConstants.journalAppBarOverlayButtonDiameter -
                  UIConstants.actionButtonIconSize) /
              2,
        ),
        iconColor: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}
