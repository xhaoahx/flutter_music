import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_music/logic/service/audio_player_service.dart';

class Background extends StatefulWidget {
  const Background({Key? key}) : super(key: key);

  @override
  _BackgroundState createState() => _BackgroundState();
}

class _BackgroundState extends State<Background> {
  Timer? _scheduler;
  MediaItem? _target;
  late final StreamSubscription _sub;

  final _opacityTween = Tween(begin: 0.4, end: 1.0);

  @override
  void initState() {
    super.initState();
    _sub = AudioPlayerService.instance.mediaItem.stream.listen(_delayedChange);
  }

  void _delayedChange(MediaItem? mediaItem) async {
    if (_scheduler != null) {
      _scheduler!.cancel();
    }
    _scheduler = Timer(
      const Duration(milliseconds: 1200),
      () {
        setState(() {
          _target = mediaItem;
          _scheduler = null;
        });
      },
    );
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final child = AnimatedSwitcher(
      child: Container(
        key: ValueKey<MediaItem?>(_target),
        constraints: BoxConstraints.expand(),
        child: _target != null
            ? Image.asset(
                _target!.artUri!.path,
                fit: BoxFit.cover,
                alignment: Alignment.center,
                color: Color.fromRGBO(121, 121, 121, 0.65),
                colorBlendMode: BlendMode.darken,
              )
            : const SizedBox(),
        //color: Colors.grey.withOpacity(0.12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.withAlpha(52),
              Colors.grey.withAlpha(128),
            ],
          ),
        ),
      ),
      duration: const Duration(milliseconds: 450),
      switchInCurve: Curves.easeIn,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation.drive(_opacityTween),
          child: child,
        );
      },
    );

    return RepaintBoundary(
      child: Transform.scale(
        scale: 1.2,
        child: child,
      ),
    );
  }
}
