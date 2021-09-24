import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter_music/logic/service/audio_player_service.dart';

class Record extends StatefulWidget {
  const Record({
    Key? key,
    required this.radius,
    required this.mediaItem,
  }) : super(key: key);

  final double radius;
  final MediaItem mediaItem;

  @override
  __RecordState createState() => __RecordState();
}

class __RecordState extends State<Record>
    with SingleTickerProviderStateMixin<Record> {
  late final StreamSubscription _playingSub;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    );

    _playingSub =
        AudioPlayerService.instance.playingStream.listen(_handlePlaying);
  }

  void _handlePlaying(bool playing) {
    if (playing) {
      _controller.repeat();
    } else {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _playingSub.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final radius = widget.radius;
    final mediaItem = widget.mediaItem;

    final record = Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // TODO: replace container with img
        color: Colors.black,
      ),
      padding: EdgeInsets.all(radius * 0.17),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius * 0.75),
          child: Image.asset(
            mediaItem.artUri.toString(),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );

    final child =  AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: 2 * math.pi * _controller.value,
          child: child,
        );
      },
      child: record,
    );

    return child;
  }
}
