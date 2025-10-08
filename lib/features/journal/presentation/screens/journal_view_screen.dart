import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_flutter_app/core/di/injection.dart';
import 'package:my_flutter_app/core/strings/app_strings.dart';
import 'package:my_flutter_app/core/theme/spacings.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
import 'package:my_flutter_app/core/utils/date_formatter.dart';

import '../../../../shared/domain/entities/journal.dart';
import '../../../../shared/presentation/widgets/tag_chip.dart';
import '../bloc/journal_view/journal_view_bloc.dart';
import '../bloc/journal_view/journal_view_event.dart';
import '../bloc/journal_view/journal_view_state.dart';
import '../strings/journal_strings.dart';
import '../widgets/journal_app_bar.dart';
import '../widgets/journal_content_section.dart';
import '../widgets/journal_delete_dialog.dart';
import '../widgets/journal_error_state.dart';
import '../widgets/journal_event_details.dart';
import '../widgets/journal_image_gallery.dart';
import '../widgets/journal_loading_state.dart';

class JournalViewScreen extends StatelessWidget {
  final String journalId;

  const JournalViewScreen({super.key, required this.journalId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<JournalViewBloc>()..add(LoadJournal(journalId)),
      child: const _JournalViewScreenView(),
    );
  }
}

class _JournalViewScreenView extends StatelessWidget {
  const _JournalViewScreenView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<JournalViewBloc, JournalViewState>(
      listener: (context, state) {
        if (state is JournalDeleted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(JournalStrings.deleteJournalSuccess)),
          );
        } else if (state is JournalError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: BlocBuilder<JournalViewBloc, JournalViewState>(
        builder: (context, state) {
          if (state is JournalLoading ||
              state is JournalInitial ||
              state is JournalDeleting) {
            return const JournalLoadingState();
          }

          if (state is JournalError) {
            return JournalErrorState(
              message: state.message,
              onRetry: () => _retryLoadJournal(context),
            );
          }

          if (state is JournalLoaded) {
            return _JournalViewContent(
              journal: state.journal,
              onEdit: () => _handleEdit(context),
              onDelete: () => _handleDelete(context, state.journal.id),
              onShare: () => _handleShare(context),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _retryLoadJournal(BuildContext context) {
    final parent = context.findAncestorWidgetOfExactType<JournalViewScreen>();
    if (parent != null) {
      context.read<JournalViewBloc>().add(LoadJournal(parent.journalId));
    }
  }

  void _handleEdit(BuildContext context) {
    // TODO: Implement edit functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(AppStrings.editFunctionalityComingSoon)),
    );
  }

  void _handleDelete(BuildContext context, String journalId) {
    JournalDeleteDialog.show(
      context,
      journalId: journalId,
      onConfirm: () {
        context.read<JournalViewBloc>().add(DeleteJournal(journalId));
      },
    );
  }

  void _handleShare(BuildContext context) {
    // TODO: Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(AppStrings.shareFunctionalityComingSoon)),
    );
  }
}

/// A widget to display the journal content with rich UI
class _JournalViewContent extends StatelessWidget {
  final Journal journal;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onShare;

  const _JournalViewContent({
    required this.journal,
    required this.onEdit,
    required this.onDelete,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          JournalAppBar(onEdit: onEdit, onDelete: onDelete, onShare: onShare),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(UIConstants.journalContentPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // JournalHeaderImage(imagePaths: journal.imagePaths),
                  // const SizedBox(height: Spacing.lg),
                  JournalEventDetails(
                    date: DateFormatter.formatJournalDate(journal.createdAt),
                    location: journal.location,
                  ),
                  const SizedBox(height: Spacing.sm),
                  if (journal.tags.isNotEmpty) ...[
                    TagChips(tags: journal.tags),
                    const SizedBox(height: Spacing.lg),
                  ],
                  JournalContentSection(content: journal.content),
                  const SizedBox(height: Spacing.lg),
                  JournalImageGallery(imagePaths: journal.imagePaths),
                  const SizedBox(height: Spacing.lg),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
