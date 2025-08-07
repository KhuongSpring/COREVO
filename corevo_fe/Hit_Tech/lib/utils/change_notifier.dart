import 'package:flutter/material.dart';

class TrainingProgressNotifier extends ChangeNotifier {
  bool _needRefresh = false;

  bool get needRefresh => _needRefresh;

  void markNeedsRefresh() {
    _needRefresh = true;
    notifyListeners();
  }

  void resetRefreshFlag() {
    _needRefresh = false;
  }
}
