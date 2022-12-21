import 'package:flutter/material.dart';

class SideMenuProvider with ChangeNotifier {
  bool _isCollapsed = false;

  bool get isCollapsed => _isCollapsed;

  void toggleIsCollapsed() {
    _isCollapsed = !isCollapsed;
    notifyListeners();
  }
}
