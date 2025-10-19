import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_flutter_app/core/di/injection.dart';
import 'package:my_flutter_app/features/journal/presentation/bloc/journal_view/journal_view_bloc.dart';
import 'package:my_flutter_app/features/journal/presentation/screens/journal_view_screen.dart';

/// Journal feature router configuration
class JournalRouter {
  static const String journalViewPath = '/journal/:journalId';
  static const String journalViewName = 'journal-view';

  /// Journal feature routes
  static List<RouteBase> get routes => [
    GoRoute(
      path: journalViewPath,
      name: journalViewName,
      pageBuilder: (context, state) {
        final journalId = state.pathParameters['journalId']!;
        final child = BlocProvider(
          create: (context) => getIt<JournalViewBloc>(),
          child: JournalViewScreen(journalId: journalId),
        );

        if (defaultTargetPlatform == TargetPlatform.iOS) {
          return CupertinoPage<void>(
            key: state.pageKey,
            child: child,
            fullscreenDialog: false,
          );
        }

        return MaterialPage<void>(key: state.pageKey, child: child);
      },
    ),
  ];
}
