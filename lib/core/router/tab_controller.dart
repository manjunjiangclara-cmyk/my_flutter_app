import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

/// Tab controller for managing bottom navigation state
@injectable
class AppTabController extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setIndex(int index) {
    if (_currentIndex != index) {
      HapticFeedback.lightImpact();
      _currentIndex = index;
      notifyListeners();
    }
  }

  void goToMemory() {
    setIndex(0);
  }

  void goToCompose() {
    setIndex(1);
  }

  void goToSettings() {
    setIndex(2);
  }
}
