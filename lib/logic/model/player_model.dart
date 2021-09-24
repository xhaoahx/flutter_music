import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_music/logic/object/lyric.dart';
import 'package:flutter_music/logic/object/state_stream.dart';
import 'package:flutter_music/logic/service/audio_player_service.dart';

part '../object/player_event.dart';

class PlayerModel with ChangeNotifier {
  PlayerModel() {
    // add listeners
    AudioPlayerService.instance.mediaItem.stream.listen(_updateLyricEntry);
    AudioPlayerService.instance.mediaItemQueueStream
        .listen(_updateMediaItemQueue);
    eventStream.listen(_handleEvent);

    AudioService.position
        .map(_mappingLyricIndex)
        .distinct()
        .pipe(_lyricIndexController);

    _lyricIndexController.stream.listen(_updateCurrentLyricIndex);
  }

  /// Event
  final StreamController<PlayerEvent> _playerEventController =
      StreamController.broadcast();
  Stream<PlayerEvent> get eventStream => _playerEventController.stream;
  void add(PlayerEvent event) => _playerEventController.add(event);

  /// Lyric
  final StreamController<int> _lyricIndexController =
      StreamController.broadcast();

  Stream<int> get lyricIndexStream => _lyricIndexController.stream;
  List<Lyric>? get lyricList => _currentLyricEntry?.lyricList;

  LyricEntry? _currentLyricEntry;

  int _currentLyricIndex = 0;
  int get currentLyricIndex => _currentLyricIndex;

  void _updateLyricEntry(MediaItem? mediaItem) async {
    final path = mediaItem?.extras?['lyric_path'];
    if (path != null) {
      // TODO: implements read lyric from network
      _currentLyricEntry = LyricEntry.form(await rootBundle.loadString(path));
    } else {
      print('missing lyric for $mediaItem');
    }
    notifyListeners();
  }

  int _mappingLyricIndex(Duration? position) {
    if (_currentLyricEntry != null && position != null) {
      var newIndex = _currentLyricEntry!.lyricList.length - 1;
      for (final lyric in _currentLyricEntry!.lyricList.reversed) {
        //print('$position : ${lyric.end}');
        if (position <= lyric.end) {
          newIndex -= 1;
        } else {
          return newIndex;
        }
      }
    }
    return 0;
  }

  void _updateCurrentLyricIndex(int? index) {
    _currentLyricIndex = index ?? 0;
  }

  /// MediaItem
  MediaItemQueueState _mediaItemQueueState = MediaItemQueueState.empty;

  void _updateMediaItemQueue(MediaItemQueueState state) {
    _mediaItemQueueState = state;
    notifyListeners();
  }

  int? get currentIndex {
    // assert(() {
    //   for (int i = 0; i < (currentMediaItemQueue?.length ?? 0); i++) {
    //     if (identical(currentMediaItem, currentMediaItemQueue?[i])) {
    //       return i == AudioPlayerService.instance.currentIndex;
    //     }
    //   }
    //   return false;
    // }());
    return AudioPlayerService.instance.currentIndex;
  }

  List<MediaItem>? get currentMediaItemQueue => _mediaItemQueueState.queue;
  MediaItem? get currentMediaItem => _mediaItemQueueState.mediaItem;

  /// Event
  void _handleEvent(PlayerEvent event) {
    print(event.runtimeType);
    event.solve(this);
  }

  @override
  void dispose() {
    _playerEventController.close();
    _lyricIndexController.close();
    _lyricIndexController.close();
    super.dispose();
  }
}
