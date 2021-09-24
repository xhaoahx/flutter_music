import 'package:flutter/material.dart';
import 'package:flutter_music/ui/config/theme/theme.dart';

export 'package:flutter_music/ui/config/theme/theme.dart';

class ThemeModel with ChangeNotifier {
  late AppTheme? _currentTheme;

  Future<void> initialize() async {
    // TODO: implements load them, use flutter theme in development
    await Future.delayed(const Duration(milliseconds: 1000));
    _currentTheme = AppTheme.flutter;
  }

  AppTheme get current {
    assert(_currentTheme != null, 'Current theme data is should not be null');
    return _currentTheme!;
  }

  void switchTheme(AppTheme target) {
    _currentTheme = target;
    notifyListeners();
  }
}
