import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_flutter_app/core/di/injection.dart';
import 'package:my_flutter_app/features/compose/presentation/bloc/compose_bloc.dart';
import 'package:my_flutter_app/features/memory/presentation/bloc/memory_bloc.dart';

/// Centralized Bloc providers for the main app screens
/// This widget manages all the Bloc instances needed by the bottom navigation screens
class AppBlocProviders extends StatelessWidget {
  final int currentIndex;
  final List<Widget> pages;

  const AppBlocProviders({
    super.key,
    required this.currentIndex,
    required this.pages,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<MemoryBloc>()),
        BlocProvider(create: (_) => getIt<ComposeBloc>()),
        // Note: SettingsBloc doesn't exist yet, but can be added when needed
        // BlocProvider(create: (_) => getIt<SettingsBloc>()),
      ],
      child: IndexedStack(index: currentIndex, children: pages),
    );
  }
}
