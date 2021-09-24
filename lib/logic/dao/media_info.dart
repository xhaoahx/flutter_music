import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_music/share/json.dart';

part 'media_info.g.dart';

@JsonSerializable()
class MediaInfo {
  const MediaInfo({
    required this.source,
    required this.cover,
    this.lyric,
  });

  final String cover;
  final String? lyric;
  final String source;

  factory MediaInfo.fromJson(Json json) => _$MediaInfoFromJson(json);

  Json toJson() => _$MediaInfoToJson(this);
}
