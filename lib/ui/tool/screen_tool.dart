import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ScreenTool {
  ScreenTool._();

  static late final ScreenTool _instance;
  static ScreenTool get instance => _instance;

  void setLandscapeForce() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  void setPortraitForce() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    assert(WidgetsBinding.instance != null);

    _instance = ScreenTool._();
    _instance._window = WidgetsBinding.instance!.window;
  }

  Size get originalPhysicalSize => _window.physicalSize;

  bool get originalIsLandscape =>
      originalPhysicalSize.width > originalPhysicalSize.height;

  late final SingletonFlutterWindow _window;
}
