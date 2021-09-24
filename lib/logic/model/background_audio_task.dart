// import 'dart:async';
// import 'package:audio_service/audio_service.dart';
// import 'package:flutter_music/logic/dao/media_info.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:audio_session/audio_session.dart';
//
// class BackgroundAudioTaskImpl extends BackgroundAudioTask {
//   /// Internal fields
//   final _player = AudioPlayer(
//     handleInterruptions: true,
//     androidApplyAudioAttributes: true,
//     handleAudioSessionActivation: true,
//   );
//   final _mediaItemQueue = List<MediaItem>.empty(growable: true);
//   late final StreamSubscription<PlaybackEvent>? _eventSubscription;
//
//   ConcatenatingAudioSource? _currentAudioSource;
//   int? _playingIndex;
//
//   List<MediaItem> get queue => List.from(_mediaItemQueue, growable: false);
//   MediaItem? get currentMediaItem =>
//       _playingIndex == null ? null : _mediaItemQueue[_playingIndex!];
//
//   /// TODO: implements onTaskRemoved
//   Future<void> onTaskRemoved() async {}
//
//   void _handleCurrentIndex(int? index) {
//     // if (index != null && _mediaItemQueue.isNotEmpty) {
//     //   index = index;
//     //   AudioServiceBackground.setMediaItem(_mediaItemQueue[index]);
//     //   AudioServiceBackground.sendCustomEvent(index);
//     // }
//     print('handleIndex: $index');
//     _playingIndex = index;
//
//     if (currentMediaItem != null) {
//       AudioServiceBackground.setMediaItem(currentMediaItem!);
//       // _logger.log(Level.info, 'switch playing index to: $_playingIndex');
//     }
//   }
//
//   AudioProcessingState _getProcessingState() {
//     switch (_player.processingState) {
//       case ProcessingState.idle:
//         return AudioProcessingState.stopped;
//       case ProcessingState.loading:
//         return AudioProcessingState.connecting;
//       case ProcessingState.buffering:
//         return AudioProcessingState.buffering;
//       case ProcessingState.ready:
//         return AudioProcessingState.ready;
//       case ProcessingState.completed:
//         return AudioProcessingState.completed;
//       default:
//         throw StateError('Invalid state: ${_player.processingState}');
//     }
//   }
//
//   /// Broadcasts the current state to all clients.
//   Future<void> _broadcastState() async {
//     await AudioServiceBackground.setState(
//       controls: [
//         MediaControl.skipToPrevious,
//         _player.playing ? MediaControl.pause : MediaControl.play,
//         MediaControl.skipToNext,
//         MediaControl.stop,
//       ],
//       systemActions: [
//         MediaAction.seekTo,
//         MediaAction.seekForward,
//         MediaAction.seekBackward,
//       ],
//       androidCompactActions: [0, 1, 2],
//       processingState: _getProcessingState(),
//       playing: _player.playing,
//       position: _player.position,
//       bufferedPosition: _player.bufferedPosition,
//       speed: _player.speed,
//     );
//   }
//
//   void _handleProcessingState(ProcessingState state) {
//     if (state == ProcessingState.completed) {
//       AudioService.stop();
//     }
//   }
//
//   @override
//   Future<void> onStart(Map<String, dynamic>? params) async {
//     _playingIndex = params?['initial'];
//
//     // config session
//     final audioSession = await AudioSession.instance;
//     await audioSession.configure(AudioSessionConfiguration.music());
//
//     // config index stream
//     _player.currentIndexStream.listen(_handleCurrentIndex);
//
//     // initialize subscription
//     _eventSubscription = _player.playbackEventStream.listen((event) {
//       _broadcastState();
//     });
//
//     _player.processingStateStream.listen(_handleProcessingState);
//   }
//
//   @override
//   Future<void> onSkipToQueueItem(String targetId) async {
//     int targetIndex =
//         _mediaItemQueue.indexWhere((element) => element.id == targetId);
//     if (targetIndex == -1) {
//       // // _logger.log(
//       //     Level.warning, 'Try to skip to un-existed id $targetId, ignored');
//     }
//     _playingIndex = targetIndex;
//     _player.seek(Duration.zero, index: targetIndex);
//     // _logger.log(Level.info, 'Skip to index: $targetIndex');
//   }
//
//   Future<void> _setQueueAndMediaSource() async {
//     await AudioServiceBackground.setQueue(_mediaItemQueue);
//     await AudioServiceBackground.setMediaItem(
//         _mediaItemQueue[_playingIndex ?? 0]);
//
//     await _player.setAudioSource(_currentAudioSource!);
//   }
//
//   // TODO: replace asset item or check uri type
//   AudioSource _parseMediaItemToSource(MediaItem mediaItem) {
//     return AudioSource.uri(
//       Uri.parse('asset:///${MediaInfo.fromJson(
//         mediaItem.extras!,
//       ).source}'),
//     );
//   }
//
//   @override
//   Future<void> onUpdateMediaItem(MediaItem mediaItem) async {
//     final targetIndex =
//         queue.indexWhere((element) => element.id == mediaItem.id);
//     queue[targetIndex] = mediaItem;
//
//     assert(_currentAudioSource != null);
//     _currentAudioSource!.children[targetIndex] =
//         _parseMediaItemToSource(mediaItem);
//
//     await _setQueueAndMediaSource();
//
//     if (targetIndex == _playingIndex) {
//       _player.seek(Duration.zero, index: _playingIndex);
//     }
//   }
//
//   @override
//   Future<void> onUpdateQueue(List<MediaItem> mediaItems) async {
//     //print('call on updated queue with: $mediaItems');
//     _mediaItemQueue.clear();
//     _mediaItemQueue.addAll(mediaItems);
//
//     _currentAudioSource = ConcatenatingAudioSource(
//       children: _mediaItemQueue.map(_parseMediaItemToSource).toList(),
//     );
//
//     await _setQueueAndMediaSource();
//     _player.seek(Duration.zero, index: _playingIndex ?? 0);
//   }
//
//   @override
//   Future<void> onAddQueueItem(MediaItem mediaItem) async {
//     _mediaItemQueue.add(mediaItem);
//
//     if (_currentAudioSource == null) {
//       _currentAudioSource = ConcatenatingAudioSource(
//         children: _mediaItemQueue.map(_parseMediaItemToSource).toList(),
//       );
//     } else {
//       _currentAudioSource!.add(_parseMediaItemToSource(mediaItem));
//     }
//
//     await _setQueueAndMediaSource();
//     // _logger.log(Level.info, 'Add mediaItem');
//   }
//
//   @override
//   Future<void> onAddQueueItemAt(MediaItem mediaItem, int index) async {
//     // TODO: check playing index
//     final current = _player.currentIndex ?? 0;
//     final position = _player.position;
//
//     _mediaItemQueue.insert(index, mediaItem);
//     _currentAudioSource ??= ConcatenatingAudioSource(
//       children: _mediaItemQueue.map(_parseMediaItemToSource).toList(),
//     );
//
//     await _currentAudioSource!.insert(
//       index,
//       _parseMediaItemToSource(mediaItem),
//     );
//
//     await AudioServiceBackground.setQueue(_mediaItemQueue);
//
//     // insert after
//     if (index > current) {
//       await _player.setAudioSource(
//         _currentAudioSource!,
//         initialIndex: current,
//         initialPosition: position,
//       );
//       await AudioServiceBackground.setMediaItem(_mediaItemQueue[current]);
//     } else {
//       await _player.setAudioSource(
//         _currentAudioSource!,
//         initialIndex: current + 1,
//         initialPosition: position,
//       );
//       await AudioServiceBackground.setMediaItem(_mediaItemQueue[current + 1]);
//     }
//
//     // _logger.log(Level.info, 'Insert mediaItem to $index');
//   }
//
//   @override
//   Future<void> onRemoveQueueItem(MediaItem mediaItem) async {
//     // TODO: check remove current
//     final targetIndex = _mediaItemQueue.indexWhere((item) => item == mediaItem);
//     final current = _player.currentIndex!;
//     final position = _player.position;
//     assert(_currentAudioSource != null);
//
//     await _currentAudioSource!.removeAt(targetIndex);
//     _mediaItemQueue.removeAt(targetIndex);
//
//     await AudioServiceBackground.setQueue(_mediaItemQueue);
//
//     // remove after
//     if (targetIndex > current) {
//       await _player.setAudioSource(
//         _currentAudioSource!,
//         initialIndex: current,
//         initialPosition: position,
//       );
//       await AudioServiceBackground.setMediaItem(_mediaItemQueue[current]);
//     }
//     // remove before
//     else {
//       await _player.setAudioSource(
//         _currentAudioSource!,
//         initialIndex: current - 1,
//         initialPosition: position,
//       );
//       await AudioServiceBackground.setMediaItem(_mediaItemQueue[current - 1]);
//     }
//
//     // _logger.log(Level.info, 'Remove mediaItem at $targetIndex');
//   }
//
//   @override
//   Future<void> onPlay() => _player.play();
//   @override
//   Future<void> onSetRepeatMode(AudioServiceRepeatMode repeatMode) {
//     switch (repeatMode) {
//       case AudioServiceRepeatMode.all:
//         _player.setLoopMode(LoopMode.all);
//         break;
//       case AudioServiceRepeatMode.one:
//         _player.setLoopMode(LoopMode.one);
//         break;
//       default:
//         _player.setLoopMode(LoopMode.off);
//         break;
//     }
//
//     return super.onSetRepeatMode(repeatMode);
//   }
//
//   @override
//   Future<void> onPause() => _player.pause();
//
//   @override
//   Future<void> onSeekTo(Duration position) => _player.seek(position);
//
//   @override
//   Future<void> onStop() async {
//     await _player.dispose();
//     await _eventSubscription?.cancel();
//     await _broadcastState();
//     // Shut down this task
//     await super.onStop();
//   }
// }
