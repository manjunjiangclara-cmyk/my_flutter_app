import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';

class UniversalSearchBar extends StatefulWidget {
  final String hintText;
  final Function(String) onSearchChanged;
  final VoidCallback? onClearSearch;
  final bool autoFocus;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final TextInputAction? textInputAction;
  final Function(String)? onSubmitted;

  const UniversalSearchBar({
    super.key,
    required this.hintText,
    required this.onSearchChanged,
    this.onClearSearch,
    this.autoFocus = true,
    this.padding,
    this.borderRadius,
    this.textInputAction = TextInputAction.search,
    this.onSubmitted,
  });

  @override
  State<UniversalSearchBar> createState() => _UniversalSearchBarState();
}

class _UniversalSearchBarState extends State<UniversalSearchBar> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.autoFocus) {
      // Auto-focus search field
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _searchFocusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    widget.onSearchChanged(query);
  }

  void _clearSearch() {
    _searchController.clear();
    _searchFocusNode.requestFocus();
    widget.onClearSearch?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          widget.padding ?? const EdgeInsets.all(UIConstants.defaultPadding),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        onTapOutside: (_) => FocusScope.of(context).unfocus(),
        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        cursorColor: Theme.of(context).colorScheme.primary,
        textInputAction: widget.textInputAction,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  onPressed: _clearSearch,
                  icon: Icon(
                    Icons.clear,
                    color: Theme.of(context).colorScheme.onSurface,
                    size: UIConstants.smallIconSize,
                  ),
                )
              : null,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              widget.borderRadius ?? UIConstants.searchBarRoundedCornerRadius,
            ),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              widget.borderRadius ?? UIConstants.searchBarRoundedCornerRadius,
            ),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              widget.borderRadius ?? UIConstants.searchBarRoundedCornerRadius,
            ),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.outline,
              width: 2.0,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: UIConstants.defaultPadding,
            vertical: UIConstants.mediumSpacing,
          ),
        ),
        onChanged: _onSearchChanged,
        onSubmitted: widget.onSubmitted,
      ),
    );
  }
}
