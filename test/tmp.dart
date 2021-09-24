

import 'dart:async';

void main(){
  final controller = StreamController<int>.broadcast();

  controller.stream.asBroadcastStream()..listen((e) => print('1  $e'));
  controller.add(4);
  controller.add(5);
  controller.stream.asBroadcastStream().listen((e) => print('2  $e'));
  controller.add(7);
  controller.add(8);

  controller.sink.close();
}