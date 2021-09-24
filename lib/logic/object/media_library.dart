import 'package:audio_service/audio_service.dart';
import 'package:flutter_music/gen/assets.gen.dart';

class MediaLibrary {
  MediaLibrary._();

  static late final MediaLibrary _instance;
  static MediaLibrary get instance => _instance;

  late final List<MediaItem> _mediaLib;

  List<MediaItem> get mediaList => List.from(_mediaLib, growable: false);

  static Future<void> initialize() async {
    _instance = MediaLibrary._();
    _instance._mediaLib = <MediaItem>[
      MediaItem(
        id: Assets.mediaLibrary.gbqq.gbqqMp3,
        title: '告白气球',
        artist: '周杰伦',
        artUri: Uri.parse(Assets.mediaLibrary.gbqq.gbqqJpeg.path),
        extras: {'lyric_path': Assets.mediaLibrary.gbqq.qbqq},
      ),
      MediaItem(
        id: Assets.mediaLibrary.monster.monsterMp3,
        title: '怪物（TV动画《BEASTARS》第二季片头曲）',
        artist: 'YAOSOBI',
        artUri: Uri.parse(Assets.mediaLibrary.monster.monsterJpg.path),
        extras: {'lyric_path': Assets.mediaLibrary.monster.monsterLrc},
      ),
      MediaItem(
        id: Assets.mediaLibrary.foreverYoung.foreverYoungMp3,
        title: 'Forever Young',
        artist: '艾怡良',
        artUri:
            Uri.parse(Assets.mediaLibrary.foreverYoung.foreverYoungJpg.path),
        extras: {
          'lyric_path': Assets.mediaLibrary.foreverYoung.foreverYoungLrc
        },
      ),
      MediaItem(
        id: Assets.mediaLibrary.aLIEz.aLIEzMp3,
        title: 'aLIEz',
        artist: 'mizuki (瑞葵),SawanoHiroyuki[nZk]',
        artUri: Uri.parse(Assets.mediaLibrary.aLIEz.aLIEzJpg.path),
        extras: {'lyric_path': Assets.mediaLibrary.aLIEz.aLIEzLrc},
      ),
      MediaItem(
        id: Assets.mediaLibrary.havana.havanaMp3,
        title: 'Havana',
        artist: 'Camila Cabello,Young Thug',
        artUri: Uri.parse(Assets.mediaLibrary.havana.havanaJpg.path),
        extras: {'lyric_path': Assets.mediaLibrary.havana.havanaLrc},
      ),
    ];
  }
}
