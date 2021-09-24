import 'package:audio_service/audio_service.dart';
import 'package:flutter_music/logic/dao/media_info.dart';

extension on MediaItem{
  MediaInfo get mediaInfo => MediaInfo.fromJson(this.extras!);
}