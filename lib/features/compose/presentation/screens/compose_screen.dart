import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_flutter_app/core/di/injection.dart';
import 'package:my_flutter_app/core/strings/app_strings.dart';
import 'package:my_flutter_app/core/theme/spacings.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
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
import 'package:my_flutter_app/features/compose/presentation/widgets/tags/tags_display.dart';

/// Main compose screen with improved organization and tap-to-edit functionality
class ComposeScreen extends StatelessWidget {
  const ComposeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ComposeBloc>(),
      child: const _ComposeScreenView(),
    );
  }
}

class _ComposeScreenView extends StatelessWidget {
  const _ComposeScreenView();

  @override
  Widget build(BuildContext context) {
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
      Navigator.of(context).pop();
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
    return state is ComposeContent ? state : const ComposeContent();
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    ComposeContent content,
    bool isPosting,
  ) {
    return ComposeAppBar(
      onPost: () =>
          context.read<ComposeBloc>().add(const ComposePostSubmitted()),
      canPost: content.canPost && !isPosting,
    );
  }

  Widget _buildBody(
    BuildContext context,
    ComposeContent content,
    bool isPosting,
  ) {
    return Column(
      children: [
        Expanded(child: _ComposeContentArea(content: content)),
        _ComposeActionArea(),
        if (isPosting) const _PostingIndicator(),
      ],
    );
  }
}

/// Main content area with tap-to-edit functionality
class _ComposeContentArea extends StatelessWidget {
  final ComposeContent content;

  const _ComposeContentArea({required this.content});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _focusTextInput(context),
      child: SingleChildScrollView(
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
      ),
    );
  }

  void _focusTextInput(BuildContext context) {
    final bloc = context.read<ComposeBloc>();
    bloc.textFocusNode.requestFocus();
  }
}

/// Text input section
class _TextInputSection extends StatelessWidget {
  final ComposeContent content;

  const _TextInputSection({required this.content});

  @override
  Widget build(BuildContext context) {
    return ComposeTextInput(
      controller: context.read<ComposeBloc>().textController,
      focusNode: context.read<ComposeBloc>().textFocusNode,
      onChanged: (text) =>
          context.read<ComposeBloc>().add(ComposeTextChanged(text)),
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

    return TagsDisplay(
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
      onAdd: (location) => bloc.add(ComposeLocationAdded(location.name)),
    );

    // Commented out for future implementation
    // final bloc = context.read<ComposeBloc>();
    // ComposeDialogs.showLocationDialog(
    //   context: context,
    //   controller: bloc.locationController,
    //   focusNode: bloc.locationFocusNode,
    //   onAdd: (location) => bloc.add(ComposeLocationAdded(location)),
    // );
  }

  void _showTagDialog(BuildContext context) {
    // TODO: Implement tag functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(AppStrings.tagFunctionalityComingSoon)),
    );

    // Commented out for future implementation
    // final bloc = context.read<ComposeBloc>();
    // final currentState = bloc.state;
    // final existingTags = currentState is ComposeContent
    //     ? currentState.selectedTags
    //     : <String>[];

    // ComposeDialogs.showTagDialog(
    //   context: context,
    //   controller: bloc.tagController,
    //   focusNode: bloc.tagFocusNode,
    //   onAdd: (tag) => bloc.add(ComposeTagAdded(tag)),
    //   existingTags: existingTags,
    // );
  }
}

/// Posting indicator
class _PostingIndicator extends StatelessWidget {
  const _PostingIndicator();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      child: const Row(
        children: [
          SizedBox(
            width: ComposeConstants.postingIndicatorSize,
            height: ComposeConstants.postingIndicatorSize,
            child: CircularProgressIndicator(
              strokeWidth: ComposeConstants.postingIndicatorStrokeWidth,
            ),
          ),
          SizedBox(width: Spacing.sm),
          Text(ComposeStrings.postingMemory),
        ],
      ),
    );
  }
}
