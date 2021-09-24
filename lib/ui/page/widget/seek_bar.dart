import 'package:flutter/material.dart';
import 'package:flutter_music/logic/object/state_stream.dart';
import 'package:flutter_music/logic/service/audio_player_service.dart';

class SeekBar extends StatefulWidget {
  const SeekBar({
    Key? key,
    required this.activeColor,
    required this.inactiveColor,
    required this.thumbColor,
    required this.height,
    this.factor = 2.5,
  }) : super(key: key);

  final Color activeColor;
  final Color inactiveColor;
  final Color thumbColor;
  final double height;
  final double factor;

  @override
  __SeekBarState createState() => __SeekBarState();
}

class __SeekBarState extends State<SeekBar> {
  double? _seekTarget;
  bool _seeking = false;

  @override
  Widget build(BuildContext context) {
    final _sliderThemeData = SliderThemeData(
      activeTrackColor: widget.activeColor,
      inactiveTrackColor: widget.inactiveColor,
      thumbColor: widget.thumbColor,
      trackHeight: widget.height,
      overlayShape: RoundSliderOverlayShape(
        overlayRadius: 6.0,
      ),
      overlayColor: Colors.black12,
      trackShape: RectangularSliderTrackShape(),
      rangeTrackShape: RoundedRectRangeSliderTrackShape(),
      thumbShape: RoundSliderThumbShape(
        enabledThumbRadius: widget.height * widget.factor,
        elevation: 1.0,
        pressedElevation: 4.0,
      ),
    );

    final service = AudioPlayerService.instance;

    return StreamBuilder<DurationState>(
      //initialData: MediaItemState.current,
      stream: service.durationStateStream,
      builder: (context, snapshot) {
        final duration = snapshot.data?.duration;
        final position = snapshot.data?.position;

        var value;
        if (position == null || duration == null) {
          value = 0.0;
        } else {
          value = _seeking
              ? _seekTarget!
              : _positionToValue(
                  position,
                  duration,
                );
        }

        final slider = Slider(
          value: _seeking ? _seekTarget! : value,
          onChangeEnd: (value) {
            assert(_seekTarget != null);
            _handleSeekPosition(
              _seekTarget!,
              duration ?? const Duration(minutes: 99),
            );
            _seeking = false;
            _seekTarget = null;
          },
          onChangeStart: (value) {
            assert(_seekTarget == null);
            _seeking = true;
            _seekTarget = value;
          },
          onChanged: (value) {
            setState(() {
              _seekTarget = value;
            });
          },
        );

        return SliderTheme(
          data: _sliderThemeData,
          child: slider,
        );
      },
    );
  }

  double _positionToValue(Duration position, Duration duration) {
    return (position.inSeconds / duration.inSeconds).clamp(0.0, 1.0);
  }

  Duration _valueToPosition(double value, Duration duration) {
    return duration * value;
  }

  void _handleSeekPosition(double percent, Duration duration) {
    // we don't setState there because video player will send stream
    AudioPlayerService.instance.seek(_valueToPosition(percent, duration));
  }
}
