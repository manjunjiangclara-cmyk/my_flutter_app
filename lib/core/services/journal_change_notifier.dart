import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

/// Notifies listeners when any journal is created or updated.
/// Consumers should refresh relevant views upon notification.
@lazySingleton
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
