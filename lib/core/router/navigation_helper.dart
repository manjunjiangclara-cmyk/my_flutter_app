import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_flutter_app/features/journal/presentation/router/journal_router.dart';

/// Navigation helper utility for consistent navigation across the app
class NavigationHelper {
  NavigationHelper._();

  /// Navigate to memory screen (handled by IndexedStack, no navigation needed)
  static void goToMemory(BuildContext context) {
    // This is now handled by the IndexedStack in BottomNavigationShell
    // No actual navigation needed
  }

  /// Navigate to compose screen (handled by IndexedStack, no navigation needed)
  static void goToCompose(BuildContext context) {
    // This is now handled by the IndexedStack in BottomNavigationShell
    // No actual navigation needed
  }

  /// Navigate to settings screen (handled by IndexedStack, no navigation needed)
  static void goToSettings(BuildContext context) {
    // This is now handled by the IndexedStack in BottomNavigationShell
    // No actual navigation needed
  }

  /// Navigate to journal view screen
  static void goToJournalView(BuildContext context, String journalId) {
    context.go(
      JournalRouter.journalViewPath.replaceAll(':journalId', journalId),
    );
  }

  /// Navigate to journal view screen using push
  static void pushToJournalView(BuildContext context, String journalId) {
    context.push(
      JournalRouter.journalViewPath.replaceAll(':journalId', journalId),
    );
  }

  /// Go back to previous screen
  static void goBack(BuildContext context) {
    context.pop();
  }

  /// Check if we can go back
  static bool canGoBack(BuildContext context) {
    return context.canPop();
  }
}
