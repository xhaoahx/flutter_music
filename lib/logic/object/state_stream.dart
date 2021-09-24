import 'package:audio_service/audio_service.dart';
import '../service/audio_player_service.dart';

class MediaItemQueueState {
  const MediaItemQueueState(this.queue, this.mediaItem);

  final List<MediaItem>? queue;
  final MediaItem? mediaItem;

  static const empty = MediaItemQueueState(const [], null);
}

class MediaItemState {
  const MediaItemState(this.mediaItem, this.position);

  final MediaItem? mediaItem;
  final Duration? position;

  static MediaItemState get current => MediaItemState(
        AudioPlayerService.instance.currentMediaItem,
        AudioPlayerService.instance.playbackState.valueOrNull?.position,
      );

  static const empty = MediaItemState(null, null);
}

class DurationState {
  const DurationState(this.duration, this.position);

  final Duration? duration;
  final Duration? position;
}
