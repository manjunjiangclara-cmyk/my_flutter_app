import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:my_flutter_app/core/di/injection.dart';
import 'package:my_flutter_app/core/services/journal_change_notifier.dart';
import 'package:my_flutter_app/core/strings.dart';
import 'package:my_flutter_app/core/theme/fonts.dart';
import 'package:my_flutter_app/core/theme/spacings.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
import 'package:my_flutter_app/core/utils/date_formatter.dart';
import 'package:my_flutter_app/features/compose/presentation/bloc/compose_bloc.dart';
import 'package:my_flutter_app/features/compose/presentation/bloc/compose_event.dart';
import 'package:my_flutter_app/features/compose/presentation/bloc/compose_state.dart';
import 'package:my_flutter_app/features/compose/presentation/constants/compose_constants.dart';
import 'package:my_flutter_app/features/compose/presentation/strings/compose_strings.dart';
import 'package:my_flutter_app/features/compose/presentation/widgets/compose_action_buttons.dart';
import 'package:my_flutter_app/features/compose/presentation/widgets/compose_app_bar.dart';
import 'package:my_flutter_app/features/compose/presentation/widgets/compose_dialogs.dart';
import 'package:my_flutter_app/features/compose/presentation/widgets/compose_text_input.dart';
import 'package:my_flutter_app/features/compose/presentation/widgets/location/location_chip.dart';
import 'package:my_flutter_app/features/compose/presentation/widgets/photo/photo_attachments.dart';
import 'package:my_flutter_app/features/compose/presentation/widgets/tags/tag_picker_bottom_sheet.dart';
import 'package:my_flutter_app/shared/presentation/widgets/tag_chip.dart';

/// Main compose screen with improved organization and tap-to-edit functionality
class ComposeScreen extends StatelessWidget {
  final String? journalId;

  const ComposeScreen({super.key, this.journalId});

  @override
  Widget build(BuildContext context) {
    return _ComposeScreenView(journalId: journalId);
  }
}

class _ComposeScreenView extends StatelessWidget {
  final String? journalId;

  const _ComposeScreenView({this.journalId});

  @override
  Widget build(BuildContext context) {
    if (journalId != null) {
      // Dispatch initialization for edit mode
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<ComposeBloc>().add(ComposeInitializeForEdit(journalId!));
      });
    }

    return BlocListener<ComposeBloc, ComposeState>(
      listener: _handleStateChanges,
      child: BlocBuilder<ComposeBloc, ComposeState>(
        builder: (context, state) {
          final content = _getContentFromState(state);
          final isPosting = state is ComposePosting;

          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: _buildAppBar(context, content, isPosting),
            body: _buildBody(context, content, isPosting),
          );
        },
      ),
    );
  }

  void _handleStateChanges(BuildContext context, ComposeState state) {
    if (state is ComposePostSuccess) {
      // Signal global change for memory refresh
      getIt<JournalChangeNotifier>().markChanged();
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(ComposeStrings.memoryLodgedSuccessfully)),
      );
    } else if (state is ComposePostFailure) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(state.message)));
    }
  }

  ComposeContent _getContentFromState(ComposeState state) {
    if (state is ComposeContent) {
      return state;
    }
    if (state is ComposePosting) {
      // Preserve selected values during posting to avoid UI flicker
      return ComposeContent(
        text: state.text,
        attachedPhotoPaths: state.attachedPhotoPaths,
        selectedTags: state.selectedTags,
        selectedLocation: state.selectedLocation,
        selectedCreatedAt: state.selectedCreatedAt,
        isPosting: true,
      );
    }
    // For initial state, return a default ComposeContent
    // This avoids unnecessary state transitions during initialization
    return const ComposeContent();
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    ComposeContent content,
    bool isPosting,
  ) {
    final date = content.selectedCreatedAt;
    final dateText = date != null
        ? DateFormatter.formatDate(date, format: 'MMMM d, yyyy')
        : AppStrings.sampleDate;
    return ComposeAppBar(
      onPost: () =>
          context.read<ComposeBloc>().add(const ComposePostSubmitted()),
      canPost: content.canPost && !isPosting,
      dateText: dateText,
      onTapDate: () => _showDatePickerAdaptive(context, date),
    );
  }

  Future<void> _showDatePickerAdaptive(
    BuildContext context,
    DateTime? initial,
  ) async {
    final platform = defaultTargetPlatform;
    if (platform == TargetPlatform.iOS) {
      await _showDateScroller(context, initial);
    } else {
      await _showMaterialDatePicker(context, initial);
    }
  }

  Future<void> _showMaterialDatePicker(
    BuildContext context,
    DateTime? initial,
  ) async {
    final now = DateTime.now();
    final firstDate = DateTime(UIConstants.datePickerFirstYear);
    final lastDate = now; // Prevent future dates
    final selected = await showDatePicker(
      context: context,
      initialDate: initial ?? now,
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: 'Select date',
      cancelText: AppStrings.cancel,
      confirmText: AppStrings.ok,
    );
    if (selected != null) {
      context.read<ComposeBloc>().add(ComposeDateSelected(selected));
    }
  }

  Future<void> _showDateScroller(
    BuildContext context,
    DateTime? initial,
  ) async {
    DateTime temp = initial ?? DateTime.now();

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(ctx).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(UIConstants.extraLargeRadius),
            ),
          ),
          padding: const EdgeInsets.only(
            left: UIConstants.defaultPadding,
            right: UIConstants.defaultPadding,
            top: UIConstants.defaultPadding,
            bottom: UIConstants.defaultPadding,
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text(AppStrings.cancel),
                    ),
                    Text(AppStrings.selectDate, style: AppTypography.bodyLarge),
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        context.read<ComposeBloc>().add(
                          ComposeDateSelected(temp),
                        );
                      },
                      child: const Text(AppStrings.ok),
                    ),
                  ],
                ),
                SizedBox(
                  height: UIConstants.cupertinoDatePickerHeight,
                  child: CupertinoTheme(
                    data: CupertinoTheme.of(ctx),
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.date,
                      initialDateTime: temp,
                      minimumDate: DateTime(
                        UIConstants.datePickerFirstYear,
                        1,
                        1,
                      ),
                      maximumDate: DateTime.now(), // Prevent future dates
                      onDateTimeChanged: (d) => temp = d,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    ComposeContent content,
    bool isPosting,
  ) {
    return Column(
      children: [
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _focusTextInput(context),
            child: _ComposeContentArea(content: content),
          ),
        ),
        _ComposeActionArea(),
        if (isPosting) const _PostingIndicator(),
      ],
    );
  }

  void _focusTextInput(BuildContext context) {
    final bloc = context.read<ComposeBloc>();
    // Request focus immediately to ensure cursor shows without delay
    if (!bloc.textFocusNode.hasFocus) {
      FocusScope.of(context).requestFocus(bloc.textFocusNode);
    }
  }
}

/// Main content area with tap-to-edit functionality
class _ComposeContentArea extends StatelessWidget {
  final ComposeContent content;

  const _ComposeContentArea({required this.content});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(UIConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TextInputSection(content: content),
          const SizedBox(height: Spacing.lg),
          _AttachmentsSection(content: content),
          const SizedBox(height: Spacing.lg),
          _LocationSection(content: content),
          const SizedBox(height: Spacing.lg),
          _TagsSection(content: content),
          _KeyboardPadding(),
        ],
      ),
    );
  }
}

/// Text input section with optimized performance
class _TextInputSection extends StatelessWidget {
  final ComposeContent content;

  const _TextInputSection({required this.content});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ComposeBloc, ComposeState>(
      buildWhen: (previous, current) {
        // Only rebuild when text content changes
        final prevText = previous is ComposeContent ? previous.text : '';
        final currText = current is ComposeContent ? current.text : '';
        return prevText != currText;
      },
      builder: (context, state) {
        final bloc = context.read<ComposeBloc>();
        return ComposeTextInput(
          controller: bloc.textController,
          focusNode: bloc.textFocusNode,
          onChanged: (text) {
            // This will automatically transition from ComposeInitial to ComposeContent
            // when user starts typing, avoiding unnecessary initialization
            bloc.add(ComposeTextChanged(text));
          },
        );
      },
    );
  }
}

/// Attachments section (photos)
class _AttachmentsSection extends StatelessWidget {
  final ComposeContent content;

  const _AttachmentsSection({required this.content});

  @override
  Widget build(BuildContext context) {
    if (content.attachedPhotoPaths.isEmpty) return const SizedBox.shrink();

    return PhotoAttachments(
      photoPaths: content.attachedPhotoPaths,
      onRemovePhoto: (index) =>
          context.read<ComposeBloc>().add(ComposePhotoRemoved(index)),
    );
  }
}

/// Location section
class _LocationSection extends StatelessWidget {
  final ComposeContent content;

  const _LocationSection({required this.content});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ComposeBloc, ComposeState>(
      buildWhen: (previous, current) {
        final prevLoc = previous is ComposeContent
            ? previous.selectedLocation
            : null;
        final currLoc = current is ComposeContent
            ? current.selectedLocation
            : null;
        return prevLoc != currLoc;
      },
      builder: (context, state) {
        final currentContent = state is ComposeContent ? state : content;
        if (currentContent.selectedLocation == null) {
          return const SizedBox.shrink();
        }

        return LocationChip(
          location: currentContent.selectedLocation!,
          onRemove: () =>
              context.read<ComposeBloc>().add(const ComposeLocationRemoved()),
        );
      },
    );
  }
}

/// Tags section
class _TagsSection extends StatelessWidget {
  final ComposeContent content;

  const _TagsSection({required this.content});

  @override
  Widget build(BuildContext context) {
    if (content.selectedTags.isEmpty) return const SizedBox.shrink();

    return TagChips(
      tags: content.selectedTags,
      onRemoveTag: (tag) =>
          context.read<ComposeBloc>().add(ComposeTagRemoved(tag)),
    );
  }
}

/// Dynamic keyboard padding
class _KeyboardPadding extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return keyboardHeight > 0
        ? SizedBox(height: keyboardHeight)
        : const SizedBox.shrink();
  }
}

/// Action buttons area
class _ComposeActionArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ComposeActionButtons(
      onAddPhoto: () =>
          context.read<ComposeBloc>().add(const ComposePhotoAddedFromGallery()),
      onAddLocation: () => _showLocationDialog(context),
      onAddTag: () => _showTagDialog(context),
    );
  }

  void _showLocationDialog(BuildContext context) {
    final bloc = context.read<ComposeBloc>();
    ComposeDialogs.showLocationDialog(
      context: context,
      controller: bloc.locationController,
      focusNode: bloc.locationFocusNode,
      onAdd: (location) => bloc.add(ComposeLocationAdded(location)),
    );
  }

  void _showTagDialog(BuildContext context) {
    final bloc = context.read<ComposeBloc>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TagPickerBottomSheet(
        initiallySelected: (bloc.state is ComposeContent)
            ? (bloc.state as ComposeContent).selectedTags
            : const [],
        onDone: (selected) {
          if (bloc.state is ComposeContent) {
            final current = (bloc.state as ComposeContent).selectedTags;
            for (final t in current) {
              if (!selected.contains(t)) {
                bloc.add(ComposeTagRemoved(t));
              }
            }
          }
          for (final t in selected) {
            bloc.add(ComposeTagAdded(t));
          }
          Navigator.of(context).pop();
        },
      ),
    );
  }
}

/// Posting indicator
class _PostingIndicator extends StatelessWidget {
  const _PostingIndicator();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      child: Row(
        children: [
          SizedBox(
            width: ComposeConstants.postingIndicatorSize,
            height: ComposeConstants.postingIndicatorSize,
            child: SpinKitRing(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(width: Spacing.sm),
          Text(ComposeStrings.postingMemory),
        ],
      ),
    );
  }
}
