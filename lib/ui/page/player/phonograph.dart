import 'dart:async';

import 'package:flutter_music/logic/model/player_model.dart';
import 'package:flutter_music/logic/service/audio_player_service.dart';
import 'package:flutter_music/ui/page/share/media_model_builder.dart';
import 'package:flutter_music/ui/page/widget/record.dart';
import 'package:provider/provider.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_music/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class Phonograph extends StatefulWidget {
  const Phonograph({Key? key}) : super(key: key);

  @override
  _PhonographState createState() => _PhonographState();
}

class _PhonographState extends State<Phonograph>
    with SingleTickerProviderStateMixin {
  late final AnimationController _handlerController;
  late final StreamSubscription _eventSub;
  late final StreamSubscription _playingSub;

  bool _shifting = false;
  bool _playing = false;

  final _handlerRadian = math.pi / 8;

  @override
  void initState() {
    super.initState();
    _handlerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _eventSub =
        context.read<PlayerModel>().eventStream.listen(_handlePlayerEvent);
    _playingSub = AudioPlayerService.instance.playbackState
        // not use distinct
        .map<bool>((s) => s.playing)
        .listen(_handlePlaying);
  }

  void _handlePlayerEvent(PlayerEvent event) {
    if (event is ShiftingStartEvent) {
      _shifting = true;
    } else if (event is ShiftingEndEvent) {
      _shifting = false;
    }
    _notifyStateChange();
  }

  void _handlePlaying(bool playing) {
    _playing = playing;
    _notifyStateChange();
  }

  void _notifyStateChange() {
    if (_playing && !_shifting) {
      _handlerController.forward();
    } else {
      _handlerController.reverse();
    }
  }

  @override
  void dispose() {
    _eventSub.cancel();
    _playingSub.cancel();
    _handlerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final size = constraints.biggest;
        final recordRadius = size.width * 0.7;

        final handler = Positioned.fromRect(
          rect: Rect.fromCenter(
            center: Offset(
              size.width * 0.5,
              size.width * 0.05,
            ),
            width: size.width * 0.8,
            height: size.width * 0.42,
          ),
          child: AnimatedBuilder(
            child: Image.asset(
              Assets.img.player.phonographHandler.path,
              fit: BoxFit.contain,
            ),
            animation: CurvedAnimation(
              parent: _handlerController,
              curve: Curves.fastLinearToSlowEaseIn,
            ),
            builder: (context, child) {
              return Transform.rotate(
                angle: _handlerRadian * (_handlerController.value + 0.35),
                child: child,
              );
            },
          ),
        );

        final container = Positioned.fromRect(
          rect: Rect.fromCenter(
            center: Offset(
              size.width * 0.5,
              size.width * 0.57,
            ),
            width: recordRadius + 9.0,
            height: recordRadius + 9.0,
          ),
          child: Container(
              decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.27),
          )),
        );

        final recordView = Positioned.fromRect(
          rect: Rect.fromCenter(
            center: Offset(
              size.width * 0.5,
              size.width * 0.57,
            ),
            width: size.width,
            height: recordRadius,
          ),
          child: _RecordView(
            //key: _recordViewKey,
            radius: recordRadius,
          ),
        );

        final toolbar = Positioned(
          left: 0.0,
          right: 0.0,
          bottom: 0.0,
          height: size.height * 0.12,
          child: _ToolBar(),
        );

        return RepaintBoundary(
          child: Stack(
            fit: StackFit.expand,
            children: [
              container,
              recordView,
              handler,
              toolbar,
            ],
          ),
        );
      },
    );
  }
}

// TODO: implements Tool Bar
class _ToolBar extends StatelessWidget {
  const _ToolBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
    );
  }
}

class _RecordView extends StatefulWidget {
  const _RecordView({
    Key? key,
    required this.radius,
  }) : super(key: key);

  final double radius;

  @override
  __RecordViewState createState() => __RecordViewState();
}

class __RecordViewState extends State<_RecordView> {
  late final StreamSubscription _eventSub;
  late final PageController _pageController;

  bool _lock = false;
  bool _ignoreScroll = false;

  static const _restorationId = 'RecordViewPage';

  @override
  void initState() {
    super.initState();

    final playerModel = context.read<PlayerModel>();
    _eventSub = playerModel.eventStream.listen(_handleEvent);
    _pageController = PageController();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _pageController.jumpToPage(context.read<PlayerModel>().currentIndex ?? 0);
    });
  }

  void _handleEvent(PlayerEvent event) async {
    if (event is SwitchEvent) {
      setState(() {
        _lock = true;
        _ignoreScroll = true;
      });

      if (event is DrivenSwitchEvent) {
        final model = context.read<PlayerModel>();
        model.add(ShiftingStartEvent());

        final index = model.currentIndex;
        if (index != null) {
          if (_pageController.hasClients) {
            await _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 450),
              curve: Curves.easeIn,
            );
          }
        }

        model.add(ShiftingEndEvent());
      }
      // page shifting
      else if (event is ShiftSwitchEvent) {
        await Future.delayed(const Duration(milliseconds: 450));
      }

      setState(() {
        _lock = false;
        _ignoreScroll = false;
      });
    }
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (_ignoreScroll) {
      return false;
    }

    final model = context.read<PlayerModel>();
    if (notification is ScrollStartNotification) {
      model.add(ShiftingStartEvent());
      return true;
    } else if (notification is ScrollEndNotification) {
      model.add(ShiftingEndEvent());
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    _pageController.dispose();
    _eventSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pageView = MediaItemQueueBuilder(
      builder: (context, queue) {
        if (queue != null && queue.isNotEmpty) {
          return PageView.builder(
            restorationId: _restorationId,
            physics: _lock
                ? const NeverScrollableScrollPhysics()
                : const AlwaysScrollableScrollPhysics(),
            controller: _pageController,
            itemBuilder: (context, index) {
              return Record(
                mediaItem: queue[index],
                radius: widget.radius,
              );
            },
            itemCount: queue.length,
            onPageChanged: (int newIndex) {
              if(newIndex != AudioPlayerService.instance.currentIndex){
                context.read<PlayerModel>().add(ShiftSwitchEvent(newIndex));
              }
            },
          );
        } else {
          return SizedBox();
        }
      },
    );

    return NotificationListener<ScrollNotification>(
      child: pageView,
      onNotification: _handleScrollNotification,
    );
  }
}
