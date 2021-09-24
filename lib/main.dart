import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'flutter_music.dart';

void main() async {
  await FlutterMusic.initialize();
  runApp(FlutterMusic());
}