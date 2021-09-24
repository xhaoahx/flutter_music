import 'dart:io';

import 'package:flutter_music/logic/object/lyric.dart';

final path = 'asset/test/gbqq/qbqq.lrc';

void main(){
  final file = File(path);

  if(file.existsSync()){
    final string = file.readAsStringSync();
    final info = LyricEntry.form(string);
    print(info);
  }
}