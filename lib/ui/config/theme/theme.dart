import 'package:flutter/material.dart';
import 'package:flutter_music/generated/l10n.dart';
import 'package:flutter_music/ui/helper/i18n.dart';

import 'flutter.dart';
import 'night.dart';

enum AppTheme {
  night,
  flutter,
}

class ThemeConfig {
  static final _data = <AppTheme, ThemeData>{
    AppTheme.night: nightTheme,
    AppTheme.flutter: flutterTheme,
  };

  static ThemeData themeOf(AppTheme appTheme) => _data[appTheme]!;

  static final _nameMap = <AppTheme, I18Getter>{
    AppTheme.flutter: (s) => s.flutterTheme,
    AppTheme.night: (s) => s.nightTheme,
  };

  static String nameOf(AppTheme appTheme, BuildContext context) {
    return _nameMap[appTheme]!(S.of(context));
  }
}
