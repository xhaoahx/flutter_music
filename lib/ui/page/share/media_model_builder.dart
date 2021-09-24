import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music/logic/model/player_model.dart';
import 'package:flutter_music/logic/service/audio_player_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_music/logic/object/state_stream.dart';

final accentColor = Colors.white.withOpacity(0.2);
final primaryColor = Colors.white.withOpacity(0.85);

class MediaItemQueueBuilder extends StatelessWidget {
  const MediaItemQueueBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  final Widget Function(BuildContext context, List<MediaItem>?) builder;

  @override
  Widget build(BuildContext context) {
    final queue = context.select<PlayerModel, List<MediaItem>?>(
      (model) => model.currentMediaItemQueue,
    );
    return builder(context, queue);
  }
}

class MediaItemBuilder extends StatelessWidget {
  const MediaItemBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  final Widget Function(BuildContext context, MediaItem?) builder;

  @override
  Widget build(BuildContext context) {
    final mediaItem = context.select<PlayerModel, MediaItem?>(
      (model) => model.currentMediaItem,
    );
    return builder(context, mediaItem);
  }
}

class PositionBuilder extends StatelessWidget {
  const PositionBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  final Widget Function(BuildContext context, Duration?) builder;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration>(
      stream: AudioService.position,
      builder: (context, snapshot) => builder(
        context,
        snapshot.data,
      ),
    );
  }
}

class DurationBuilder extends StatelessWidget {
  const DurationBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  final Widget Function(BuildContext, Duration?) builder;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration?>(
      stream: AudioPlayerService.instance.durationStream,
      builder: (context, snapshot){
        return builder(context, snapshot.data);
      },
    );
  }
}
