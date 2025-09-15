import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/fonts.dart';
import 'package:my_flutter_app/core/theme/spacings.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';

/// A widget to display a list of tags as chips with expandable functionality.
class TagChips extends StatefulWidget {
  final List<String> tags;
  final double spacing;
  final double runSpacing;

  const TagChips({
    required this.tags,
    this.spacing = Spacing.sm,
    this.runSpacing = Spacing.xs,
    super.key,
  });

  @override
  State<TagChips> createState() => _TagChipsState();
}

class _TagChipsState extends State<TagChips> {
  bool _isExpanded = false;
  int _tagsInFirstRow = 0;
  final GlobalKey _wrapKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // Initialize with all tags, then calculate after first build
    _tagsInFirstRow = widget.tags.length;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Calculate after the widget is built and has dimensions
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateTagsInFirstRow();
    });
  }

  void _calculateTagsInFirstRow() {
    if (widget.tags.isEmpty) return;

    final RenderBox? renderBox =
        _wrapKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final double availableWidth = renderBox.size.width;
    if (availableWidth <= 0) return;

    // Calculate how many tags actually fit in one row
    int maxTags = 0;
    double currentWidth = 0;

    for (int i = 0; i < widget.tags.length; i++) {
      final tag = widget.tags[i];
      final tagWidth = _estimateTagWidth(tag);

      // Add spacing between tags (except for the first one)
      if (i > 0) {
        currentWidth += widget.spacing;
      }

      // Check if this tag fits
      if (currentWidth + tagWidth <= availableWidth) {
        currentWidth += tagWidth;
        maxTags = i + 1;
      } else {
        break;
      }
    }

    // Ensure we show at least one tag if there are tags available
    if (maxTags == 0 && widget.tags.isNotEmpty) {
      maxTags = 1;
    }

    if (mounted) {
      setState(() {
        _tagsInFirstRow = maxTags;
      });
    }
  }

  double _estimateTagWidth(String tag) {
    // More accurate estimation based on text metrics
    final textPainter = TextPainter(
      text: TextSpan(text: tag, style: AppTypography.labelSmall),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    // Add padding and border width based on TagChip's actual padding
    return textPainter.width +
        (Spacing.xs * 2) +
        16; // horizontal padding + some margin
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.tags.isEmpty) return const SizedBox.shrink();

    // Only show expand option if there are actually more tags that don't fit
    final bool hasMoreTags =
        widget.tags.length > _tagsInFirstRow && _tagsInFirstRow > 0;
    final List<String> displayTags = _isExpanded || !hasMoreTags
        ? widget.tags
        : widget.tags.take(_tagsInFirstRow).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          key: _wrapKey,
          spacing: widget.spacing,
          runSpacing: widget.runSpacing,
          children: [
            ...displayTags.map<Widget>((tag) => TagChip(tag: tag)),
            if (hasMoreTags && !_isExpanded) _buildMoreButton(),
          ],
        ),
        if (hasMoreTags && _isExpanded) _buildCollapseButton(),
      ],
    );
  }

  Widget _buildMoreButton() {
    return GestureDetector(
      onTap: _toggleExpanded,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.xs,
          vertical: Spacing.xxs,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(UIConstants.defaultRadius),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '+${widget.tags.length - _tagsInFirstRow}',
              style: AppTypography.labelSmall.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 2),
            Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCollapseButton() {
    return Padding(
      padding: const EdgeInsets.only(top: Spacing.xs),
      child: GestureDetector(
        onTap: _toggleExpanded,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Show less',
              style: AppTypography.labelSmall.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_up,
              size: 16,
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}

class TagChip extends StatelessWidget {
  final String tag;
  final double chipHorizontalPadding;
  final double chipVerticalPadding;

  const TagChip({
    super.key,
    required this.tag,
    this.chipHorizontalPadding = Spacing.xs,
    this.chipVerticalPadding = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(tag, style: AppTypography.labelSmall),
      backgroundColor: Theme.of(
        context,
      ).colorScheme.outline.withValues(alpha: 0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UIConstants.defaultRadius),
        side: BorderSide.none,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: chipHorizontalPadding,
        vertical: chipVerticalPadding,
      ),
    );
  }
}
