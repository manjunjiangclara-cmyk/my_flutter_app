import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_flutter_app/core/di/injection.dart';
import 'package:my_flutter_app/core/router/navigation_helper.dart';
import 'package:my_flutter_app/core/theme/colors.dart';
import 'package:my_flutter_app/core/theme/fonts.dart';
import 'package:my_flutter_app/core/theme/spacings.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';

import '../../../../shared/domain/entities/journal.dart';
import '../../../../shared/domain/usecases/get_journal_by_id.dart';
import '../bloc/journal_view/journal_view_bloc.dart';
import '../bloc/journal_view/journal_view_event.dart';
import '../bloc/journal_view/journal_view_state.dart';
import '../widgets/tag_chip.dart';

class JournalViewScreen extends StatelessWidget {
  final String journalId;
  final GetJournalById getJournalById;

  const JournalViewScreen({
    super.key,
    required this.journalId,
    required this.getJournalById,
  });

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
    return BlocBuilder<JournalViewBloc, JournalViewState>(
      builder: (context, state) {
        if (state is JournalLoading || state is JournalInitial) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (state is JournalError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: Spacing.md),
                  ElevatedButton(
                    onPressed: () {
                      // Get the journal ID from the parent widget
                      final parent = context
                          .findAncestorWidgetOfExactType<JournalViewScreen>();
                      if (parent != null) {
                        context.read<JournalViewBloc>().add(
                          LoadJournal(parent.journalId),
                        );
                      }
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }
        if (state is JournalLoaded) {
          return _JournalViewContent(journal: state.journal);
        }
        return const SizedBox.shrink();
      },
    );
  }
}

/// A widget to display the journal content with rich UI
class _JournalViewContent extends StatelessWidget {
  final Journal journal;

  const _JournalViewContent({required this.journal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => NavigationHelper.goBack(context),
            ),
            actions: <Widget>[
              Icon(Icons.share),
              SizedBox(width: Spacing.lg),
              Icon(Icons.edit),
              SizedBox(width: Spacing.lg),
            ],
            floating: true,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(Spacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _HeaderImage(imageUrls: journal.imageUrls),
                  SizedBox(height: Spacing.lg),
                  _EventDetailsHeader(
                    date: _formatDate(journal.createdAt),
                    location:
                        'Unknown', // Journal entity doesn't have location field
                  ),
                  SizedBox(height: Spacing.sm),
                  if (journal.tags.isNotEmpty) ...[
                    TagChips(tags: journal.tags),
                    SizedBox(height: Spacing.lg),
                  ],
                  _ContentSection(content: journal.content),
                  SizedBox(height: Spacing.lg),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    // Format the date as "Thursday, August 28" style
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    final weekday = weekdays[date.weekday - 1];
    final month = months[date.month - 1];
    final day = date.day;

    return '$weekday, $month $day';
  }
}

/// A widget to display a section of content with multiple paragraphs.
class _ContentSection extends StatelessWidget {
  final String content;

  const _ContentSection({required this.content});

  @override
  Widget build(BuildContext context) {
    // Split content into paragraphs (assuming double newlines separate paragraphs)
    final paragraphs = content
        .split('\n\n')
        .where((p) => p.trim().isNotEmpty)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        for (int i = 0; i < paragraphs.length; i++) ...<Widget>[
          Text(paragraphs[i], style: AppTypography.bodyLarge),
          if (i < paragraphs.length - 1) SizedBox(height: Spacing.lg),
        ],
      ],
    );
  }
}

/// A widget to display the main header image.
class _HeaderImage extends StatelessWidget {
  final List<String> imageUrls;

  const _HeaderImage({required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: double.infinity,
      color: AppColors.border,
      child: imageUrls.isNotEmpty
          ? Image.network(
              imageUrls.first,
              fit: BoxFit.cover,
              errorBuilder:
                  (BuildContext context, Object error, StackTrace? stackTrace) {
                    return _buildPlaceholder();
                  },
            )
          : _buildPlaceholder(),
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Icon(
        Icons.image,
        size: UIConstants.largeIconSize,
        color: AppColors.textSecondary,
      ),
    );
  }
}

/// A widget to display event details like date and location.
class _EventDetailsHeader extends StatelessWidget {
  final String date;
  final String location;

  const _EventDetailsHeader({required this.date, required this.location});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(date, style: AppTypography.titleMedium),
        Row(
          children: <Widget>[
            Icon(
              Icons.location_on,
              size: UIConstants.smallIconSize,
              color: AppColors.textSecondary,
            ),
            SizedBox(width: Spacing.xs),
            Text(location, style: AppTypography.labelSmall),
          ],
        ),
      ],
    );
  }
}
