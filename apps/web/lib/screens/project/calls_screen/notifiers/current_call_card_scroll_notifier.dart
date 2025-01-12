import 'package:flutter/material.dart';

/// Данные скролла текущего звонка
class CurrentCallCardScrollNotifier with ChangeNotifier {
  double _currentCallCardOffset = 0;
  double get offset => _currentCallCardOffset;

  void update(double scrollOffset) => _currentCallCardOffset = scrollOffset;
  void notify() => notifyListeners();
}