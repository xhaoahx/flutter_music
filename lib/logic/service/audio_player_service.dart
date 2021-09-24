import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_music/logic/object/state_stream.dart';
import 'package:rxdart/rxdart.dart';

class AudioPlayerService extends BaseAudioHandler
    with QueueHandler, SeekHandler {
  AudioPlayerService._() {
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);
    _audioSource =
        ConcatenatingAudioSource(children: List.empty(growable: true));
    playbackState.listen(_jumpToNext);
  }

  static late final AudioPlayerService _instance;
  final _player = AudioPlayer();
  late ConcatenatingAudioSource _audioSource;

  static AudioPlayerService get instance => _instance;

  bool get loading => _loading;
  bool _loading = false;

  static Future<void> initialize() async {
    _instance = await AudioService.init<AudioPlayerService>(
      builder: () => AudioPlayerService._(),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.ryanheise.myapp.channel.audio',
        androidNotificationChannelName: 'Audio playback',
        androidNotificationOngoing: true,
      ),
    );
  }

  void _jumpToNext(PlaybackState state) {
    print(state.processingState);

    // if (state.processingState == AudioProcessingState.completed) {
    //   // if (currentIndex != (queue.valueOrNull?.length ?? 0) - 1) {
    //   //   skipToNext();
    //   // } else {
    //   //   pause();
    //   // }
    //   pause();
    // }
  }

  Stream<MediaItemQueueState> get mediaItemQueueStream =>
      Rx.combineLatest2<List<MediaItem>?, MediaItem?, MediaItemQueueState>(
        _instance.queue.stream,
        _instance.mediaItem.stream,
        (a, b) => MediaItemQueueState(a, b),
      );

  Stream<MediaItemState> get mediaItemStream =>
      Rx.combineLatest2<MediaItem?, Duration?, MediaItemState>(
        _instance.mediaItem.stream,
        AudioService.position,
        (a, b) => MediaItemState(a, b),
      );

  Stream<DurationState> get durationStateStream =>
      Rx.combineLatest2<Duration?, Duration?, DurationState>(
        _player.durationStream,
        _player.positionStream,
        (a, b) => DurationState(a, b),
      );

  Stream<bool> get playingStream =>
      _instance.playbackState.map<bool>((e) => e.playing);

  int? get currentIndex => _player.currentIndex;
  MediaItem? get currentMediaItem => mediaItem.valueOrNull;

  AudioSource _parseSource(MediaItem mediaItem) {
    return AudioSource.uri(Uri.parse(
      'asset:///${mediaItem.id}',
    ));
  }

  Stream<Duration?> get durationStream => _player.durationStream;

  Future<Duration?> load() async {
    return _player.load();
  }

  @override
  Future<void> addQueueItem(MediaItem mediaItem) async {
    if (queue.valueOrNull?.contains(mediaItem) ?? false) return;

    _audioSource..add(_parseSource(mediaItem));
    await super.addQueueItem(mediaItem);
  }

  @override
  Future<void> insertQueueItem(int index, MediaItem mediaItem) async {
    if (queue.valueOrNull?.contains(mediaItem) ?? false) return;

    await _audioSource.insert(0, _parseSource(mediaItem));
    await super.insertQueueItem(index, mediaItem);

    final currentIndex = _player.currentIndex;
    if (currentIndex != null && index >= currentIndex) {
      _player.seek(Duration.zero, index: currentIndex + 1);
    }
  }

  @override
  Future<void> skipToPrevious() async {
    if (_player.currentIndex == 0) {
      // return await skipToQueueItem(queue.valueOrNull!.length - 1);
      return;
    }
    await super.skipToPrevious();
    seek(Duration.zero);
  }

  @override
  Future<void> skipToNext() async {
    if (_player.currentIndex == queue.valueOrNull!.length - 1) {
      // return await skipToQueueItem(0);
      return;
    }
    await super.skipToNext();
    seek(Duration.zero);
  }

  @override
  Future<void> skipToQueueItem(int index) async {
    assert(index >= 0 && index < queue.valueOrNull!.length);
    await _player.setAudioSource(
      _audioSource,
      initialIndex: index,
      initialPosition: Duration.zero,
    );
    mediaItem.add(queue.valueOrNull![index]);
    return super.skipToQueueItem(index);
  }

  @override
  Future<void> addQueueItems(List<MediaItem> mediaItems) async {
    if (queue.valueOrNull?.contains(mediaItem) ?? false) return;

    _player.setAudioSource(
      _audioSource..addAll(mediaItems.map<AudioSource>(_parseSource).toList()),
      initialIndex: _player.currentIndex,
      initialPosition: _player.position,
    );
    await super.addQueueItems(mediaItems);
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> stop() => _player.stop();

  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        MediaControl.rewind,
        if (_player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
        MediaControl.fastForward,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 3],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: _player.playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: event.currentIndex,
    );
  }
}
