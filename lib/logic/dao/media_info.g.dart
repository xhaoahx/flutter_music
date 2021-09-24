// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MediaInfo _$MediaInfoFromJson(Map<String, dynamic> json) {
  return MediaInfo(
    source: json['source'] as String,
    cover: json['cover'] as String,
    lyric: json['lyric'] as String?,
  );
}

Map<String, dynamic> _$MediaInfoToJson(MediaInfo instance) => <String, dynamic>{
      'cover': instance.cover,
      'lyric': instance.lyric,
      'source': instance.source,
    };
