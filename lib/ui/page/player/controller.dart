import 'package:flutter/material.dart';
import 'package:flutter_music/logic/model/player_model.dart';
import 'package:flutter_music/logic/service/audio_player_service.dart';
import 'package:flutter_music/ui/page/share/media_model_builder.dart';
import 'package:flutter_music/ui/page/widget/seek_bar.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';


class PlayerController extends StatelessWidget {
  const PlayerController({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final indicatorStyle = TextStyle(
      fontSize: 11.0,
      color: primaryColor,
      fontWeight: FontWeight.w400,
    );
    // prefix indicator
    final positionIndicator = PositionBuilder(
      builder: (context, position) {
        return Text(
          _write(position ?? Duration.zero),
          style: indicatorStyle,
        );
      },
    );

    final seekbar = SeekBar(
      activeColor: accentColor,
      inactiveColor: accentColor,
      thumbColor: primaryColor,
      height: 1.5,
    );

    final durationIndicator = DurationBuilder(
      builder: (context, duration) {
        return Text(
          _write(duration ?? const Duration(minutes: 99)),
          style: indicatorStyle,
        );
      },
    );

    final seekController = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      child: Row(
        children: [
          positionIndicator,
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: seekbar,
            ),
          ),
          durationIndicator,
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
    );

    final playController = _PlayController();

    return Column(
      children: [
        seekController,
        playController,
      ],
    );
  }

  String _write(Duration value) {
    final minute = value.inMinutes;
    final second = value.inSeconds - minute * Duration.secondsPerMinute;
    return ''
        '${minute < 10 ? '0$minute' : '$minute'}:'
        '${second < 10 ? '0$second' : '$second'}';
  }
}

class _PlayController extends StatelessWidget {
  const _PlayController({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final loopBtn = _LoopModeBtn();
    final model = context.read<PlayerModel>();
    final size = 30.0;

    final previousBtn = IconButton(
      onPressed: () => model.add(DrivenSwitchEvent(true)),
      icon: Icon(
        Icons.skip_previous_outlined,
        color: primaryColor,
        size: size,
      ),
    );

    final playBtn = Container(
      alignment: Alignment.center,
      child: StreamBuilder<bool>(
        initialData: false,
        stream: AudioPlayerService.instance.playingStream,
        builder: (context, snapshot) {
          return snapshot.data ?? false
              ? IconButton(
                  onPressed: () => model.add(PausingEvent()),
                  icon: Icon(
                    Icons.pause,
                    color: primaryColor,
                    size: size,
                  ),
                )
              : IconButton(
                  onPressed: () => model.add(PlayingEvent()),
                  icon: Icon(
                    Icons.play_arrow,
                    color: primaryColor,
                    size: size,
                  ),
                );
        },
      ),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: primaryColor,
          width: 1.0,
        ),
      ),
    );

    final nextBtn = IconButton(
      onPressed: () => model.add(DrivenSwitchEvent(false)),
      icon: Icon(
        Icons.skip_next_outlined,
        color: primaryColor,
        size: size,
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 32.0,
      ),
      child: Row(
        children: [
          //loopBtn,
          previousBtn,
          playBtn,
          nextBtn,
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
    );
  }
}

class _LoopModeBtn extends StatefulWidget {
  const _LoopModeBtn({Key? key}) : super(key: key);

  @override
  _LoopModeBtnState createState() => _LoopModeBtnState();
}

class _LoopModeBtnState extends State<_LoopModeBtn> {
  final LoopMode _current = LoopMode.all;

  @override
  Widget build(BuildContext context) {
    late final icon;
    switch (_current) {
      case LoopMode.all:
      case LoopMode.off:
      case LoopMode.one:
        icon = Icons.loop;
        break;
    }
    return IconButton(
      onPressed: () {
        //AudioService.setRepeatMode(AudioServiceRepeatMode.all);
      },
      icon: Icon(icon),
    );
  }
}
