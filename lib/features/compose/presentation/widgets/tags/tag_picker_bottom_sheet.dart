import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/database/dao/tag_dao.dart';
import '../../../../../core/strings.dart';
import '../../../../../core/theme/fonts.dart';
import '../../../../../core/theme/spacings.dart';
import '../../../../../core/theme/ui_constants.dart';
import '../../../../../shared/presentation/widgets/search_bar.dart';
import '../../../../../shared/presentation/widgets/tag_chip.dart';

class TagPickerBottomSheet extends StatefulWidget {
  final List<String> initiallySelected;
  final void Function(List<String>) onDone;

  const TagPickerBottomSheet({
    super.key,
    required this.initiallySelected,
    required this.onDone,
  });

  @override
  State<TagPickerBottomSheet> createState() => _TagPickerBottomSheetState();
}

class _TagPickerBottomSheetState extends State<TagPickerBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  final TagDao _tagDao = TagDao();

  List<String> _all = [];
  List<String> _filtered = [];
  late List<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = List<String>.from(widget.initiallySelected);
    _loadTags();
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _loadTags({String? filter}) async {
    final results = await _tagDao.getTags(filter: filter);
    setState(() {
      _all = results;
      _filtered = results;
    });
  }

  void _onSearchChanged() {
    final q = _searchController.text.trim();
    setState(() {
      _filtered = _all
          .where((t) => t.toLowerCase().contains(q.toLowerCase()))
          .toList();
    });
  }

  void _toggleTag(String tag) {
    setState(() {
      if (_selected.contains(tag)) {
        _selected.remove(tag);
      } else {
        _selected.add(tag);
      }
    });
  }

  Future<void> _addQueryAsTag() async {
    final q = _searchController.text.trim();
    if (q.isEmpty) return;
    HapticFeedback.lightImpact();
    setState(() {
      if (!_selected.contains(q)) {
        _selected.add(q);
      }
      if (!_all.contains(q)) {
        _all = [..._all, q];
        _filtered = [..._filtered, q];
      }
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * UIConstants.tagPickerHeight,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(UIConstants.locationPickerCornerRadius),
          topRight: Radius.circular(UIConstants.locationPickerCornerRadius),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: Spacing.md),
            width: UIConstants.bottomSheetHandleWidth,
            height: UIConstants.bottomSheetHandleHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                UIConstants.bottomSheetHandleRadius,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: UIConstants.defaultPadding,
              vertical: Spacing.xs,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.selected,
                  style: AppTypography.labelSmall.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: UIConstants.defaultButtonHeight,
                  child: ElevatedButton(
                    onPressed: () => widget.onDone(_selected),
                    child: const Text(AppStrings.ok),
                  ),
                ),
              ],
            ),
          ),
          if (_selected.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: UIConstants.defaultPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: Spacing.xs),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (final tag in _selected) ...[
                          TagChip(tag: tag, onRemoveTag: (t) => _toggleTag(t)),
                          const SizedBox(width: Spacing.sm),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          AnimatedSwitcher(
            duration: UIConstants.defaultAnimation,
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (child, animation) {
              return SizeTransition(sizeFactor: animation, child: child);
            },
            child: UniversalSearchBar(
              key: ValueKey(_selected.length),
              hintText: AppStrings.enterTagHint,
              autoFocus: false,
              onSearchChanged: (query) {
                _searchController.text = query;
                _onSearchChanged();
              },
              onClearSearch: () {
                _searchController.clear();
                _onSearchChanged();
              },
              onSubmitted: (_) => _addQueryAsTag(),
            ),
          ),
          const SizedBox(height: Spacing.xs),
          Expanded(
            child: _filtered.isEmpty
                ? Center(
                    child: Text(
                      AppStrings.noTags,
                      style: AppTypography.bodyMedium.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  )
                : ListView.separated(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.symmetric(
                      horizontal: UIConstants.defaultPadding,
                      vertical: Spacing.sm,
                    ),
                    itemBuilder: (_, i) {
                      final display = _filtered
                          .where((t) => !_selected.contains(t))
                          .toList();
                      final tag = display[i];
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: _buildResultChip(context, tag),
                      );
                    },
                    separatorBuilder: (_, __) => Divider(
                      height: 1,
                      thickness: 0.5,
                      color: Theme.of(
                        context,
                      ).colorScheme.outline.withValues(alpha: 0.2),
                    ),
                    itemCount: _filtered
                        .where((t) => !_selected.contains(t))
                        .length,
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildResultChip(BuildContext context, String tag) {
    final bool selected = _selected.contains(tag);

    if (selected) {
      // Selected tags are removed from results; guard to avoid rendering
      return const SizedBox.shrink();
    }

    // Use TagChip widget without remove button for search results (read-only)
    return GestureDetector(
      onTap: () => _toggleTag(tag),
      child: TagChip(tag: tag),
    );
  }
}
