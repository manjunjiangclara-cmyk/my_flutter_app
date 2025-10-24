import 'package:flutter/foundation.dart';

/// Notifies listeners when any journal is created or updated.
/// Consumers should refresh relevant views upon notification.
class JournalChangeNotifier extends ChangeNotifier {
  bool _hasPendingChange = false;

  bool get hasPendingChange => _hasPendingChange;

  void markChanged() {
    _hasPendingChange = true;
    notifyListeners();
  }

  void consume() {
    _hasPendingChange = false;
  }
}
