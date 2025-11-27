import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_flutter_app/core/di/injection.dart';
import 'package:my_flutter_app/core/router/navigation_helper.dart';
import 'package:my_flutter_app/core/services/journal_change_notifier.dart';
import 'package:my_flutter_app/core/strings/app_strings.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
import 'package:my_flutter_app/core/utils/share_capture_util.dart';
import 'package:my_flutter_app/core/utils/ui_calculations.dart';
import 'package:my_flutter_app/features/journal/presentation/widgets/journal_app_bar_overlay.dart';
import 'package:my_flutter_app/features/journal/presentation/widgets/journal_content_scroll.dart';
import 'package:my_flutter_app/features/journal/presentation/widgets/journal_fab_buttons.dart';
import 'package:my_flutter_app/shared/presentation/widgets/share_options_bottom_sheet.dart';
import 'package:screenshot/screenshot.dart';

import '../../../../shared/domain/entities/journal.dart';
import '../bloc/journal_view/journal_view_bloc.dart';
import '../bloc/journal_view/journal_view_event.dart';
import '../bloc/journal_view/journal_view_state.dart';
import '../strings/journal_strings.dart';
// Removed Sliver-based JournalAppBar usage in favor of overlay app bar
import '../widgets/journal_delete_dialog.dart';
import '../widgets/journal_error_state.dart';
// import '../widgets/journal_image_gallery.dart';
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
          // Signal global change for memory refresh
          getIt<JournalChangeNotifier>().markChanged();
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

  Future<void> _handleEdit(BuildContext context) async {
    final parent = context.findAncestorWidgetOfExactType<JournalViewScreen>();
    if (parent != null) {
      final updated = await context.pushNamed(
        'compose-edit',
        pathParameters: {'journalId': parent.journalId},
      );
      if (updated == true) {
        context.read<JournalViewBloc>().add(LoadJournal(parent.journalId));
      }
    }
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
}

/// A widget to display the journal content with rich UI
class _JournalViewContent extends StatefulWidget {
  final Journal journal;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _JournalViewContent({
    required this.journal,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<_JournalViewContent> createState() => _JournalViewContentState();
}

class _JournalViewContentState extends State<_JournalViewContent> {
  bool _isAppBarVisible = false;
  bool _isSharing = false;
  final ScreenshotController _screenshotController = ScreenshotController();
  final GlobalKey _captureKey = GlobalKey();

  void _toggleAppBar() {
    HapticFeedback.lightImpact();
    setState(() {
      _isAppBarVisible = !_isAppBarVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Always use only status bar height for content padding; overlay app bar should not push content
    final statusBarHeight = UICalculations.getTopBarArea(context, false);

    final scaffold = Scaffold(
      body: Stack(
        children: [
          // Main scrollable content
          GestureDetector(
            onTap: _toggleAppBar,
            child: Screenshot(
              controller: _screenshotController,
              child: JournalContentScroll(
                journal: widget.journal,
                captureKey: _captureKey,
                statusBarHeight: statusBarHeight,
              ),
            ),
          ),

          // Overlay app bar (does not push content) with gradient across status bar + toolbar
          JournalAppBarOverlay(
            statusBarHeight: statusBarHeight,
            isVisible: _isAppBarVisible,
            onClose: () => NavigationHelper.goBack(context),
            onEdit: widget.onEdit,
            onDelete: widget.onDelete,
            onShareTap: () => _handleShareTap(context),
          ),

          // FAB buttons in bottom right corner
          JournalFabButtons(
            isVisible: _isAppBarVisible,
            onEdit: widget.onEdit,
            onDelete: widget.onDelete,
            onShareTap: () => _handleShareTap(context),
          ),

          if (_isSharing) ...[
            Positioned.fill(
              child: ModalBarrier(
                dismissible: false,
                color: Theme.of(context).colorScheme.scrim.withValues(
                  alpha: UIConstants.dialogBarrierOpacity,
                ),
              ),
            ),
            const Center(child: CircularProgressIndicator()),
          ],
        ],
      ),
    );

    // Only use WillPopScope on Android to avoid blocking iOS swipe back gesture
    if (defaultTargetPlatform == TargetPlatform.android) {
      return WillPopScope(onWillPop: () async => !_isSharing, child: scaffold);
    }

    return scaffold;
  }

  Future<void> _handleShareTap(BuildContext context) async {
    final selected = await ShareOptionsBottomSheet.show(context);
    if (selected == null) return;

    if (selected == ShareOption.shareToApps) {
      await _shareToApps(context);
    } else if (selected == ShareOption.saveToPhotos) {
      await _saveToPhotos(context);
    }
  }

  Future<void> _shareToApps(BuildContext context) async {
    try {
      setState(() {
        _isSharing = true;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(AppStrings.shareImagePreparing)));
      final outcome = await ShareCaptureUtil.shareToApps(
        context: context,
        boundaryKey: _captureKey,
        fileNamePrefix: 'hibi_journal',
        subject: 'Journal',
      );
      if (outcome == ShareOutcome.failed) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(AppStrings.shareFailed)));
      } else if (outcome == ShareOutcome.success) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(AppStrings.shareSuccess)));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(AppStrings.shareFailed)));
    } finally {
      if (mounted) {
        setState(() {
          _isSharing = false;
        });
      }
    }
  }

  Future<void> _saveToPhotos(BuildContext context) async {
    try {
      setState(() {
        _isSharing = true;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(AppStrings.shareImagePreparing)));
      final success = await ShareCaptureUtil.saveToPhotos(
        context: context,
        boundaryKey: _captureKey,
        fileNamePrefix: 'hibi_journal',
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success ? AppStrings.shareSaved : AppStrings.shareFailed,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(AppStrings.shareFailed)));
    } finally {
      if (mounted) {
        setState(() {
          _isSharing = false;
        });
      }
    }
  }
}
