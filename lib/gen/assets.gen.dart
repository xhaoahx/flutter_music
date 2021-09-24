/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

import 'package:flutter/widgets.dart';

class $AssetsFontsGen {
  const $AssetsFontsGen();

  String get hwkt => 'assets/fonts/hwkt.ttf';
}

class $AssetsImgGen {
  const $AssetsImgGen();

  $AssetsImgCommonGen get common => const $AssetsImgCommonGen();
  $AssetsImgPlayerGen get player => const $AssetsImgPlayerGen();
}

class $AssetsMediaLibraryGen {
  const $AssetsMediaLibraryGen();

  $AssetsMediaLibraryALIEzGen get aLIEz => const $AssetsMediaLibraryALIEzGen();
  $AssetsMediaLibraryForeverYoungGen get foreverYoung =>
      const $AssetsMediaLibraryForeverYoungGen();
  $AssetsMediaLibraryGbqqGen get gbqq => const $AssetsMediaLibraryGbqqGen();
  $AssetsMediaLibraryHavanaGen get havana =>
      const $AssetsMediaLibraryHavanaGen();
  $AssetsMediaLibraryMonsterGen get monster =>
      const $AssetsMediaLibraryMonsterGen();
}

class $AssetsImgCommonGen {
  const $AssetsImgCommonGen();

  AssetGenImage get avatar =>
      const AssetGenImage('assets/img/common/avatar.png');
  AssetGenImage get bg1 => const AssetGenImage('assets/img/common/bg1.jpg');
  AssetGenImage get bg2 => const AssetGenImage('assets/img/common/bg2.jpg');
  AssetGenImage get calendar =>
      const AssetGenImage('assets/img/common/calendar.png');
  AssetGenImage get chart => const AssetGenImage('assets/img/common/chart.png');
  AssetGenImage get clock => const AssetGenImage('assets/img/common/clock.png');
  AssetGenImage get close => const AssetGenImage('assets/img/common/close.png');
  AssetGenImage get disc => const AssetGenImage('assets/img/common/disc.jpg');
  AssetGenImage get divider =>
      const AssetGenImage('assets/img/common/divider.png');
  AssetGenImage get download =>
      const AssetGenImage('assets/img/common/download.png');
  AssetGenImage get email => const AssetGenImage('assets/img/common/email.png');
  AssetGenImage get hamburger =>
      const AssetGenImage('assets/img/common/hamburger.png');
  AssetGenImage get heart => const AssetGenImage('assets/img/common/heart.png');
  AssetGenImage get lib => const AssetGenImage('assets/img/common/lib.png');
  AssetGenImage get list => const AssetGenImage('assets/img/common/list.png');
  AssetGenImage get logo => const AssetGenImage('assets/img/common/logo.png');
  AssetGenImage get logo2 => const AssetGenImage('assets/img/common/logo2.png');
  AssetGenImage get menu => const AssetGenImage('assets/img/common/menu.png');
  AssetGenImage get next => const AssetGenImage('assets/img/common/next.png');
  AssetGenImage get pause => const AssetGenImage('assets/img/common/pause.png');
  AssetGenImage get pc => const AssetGenImage('assets/img/common/pc.png');
  AssetGenImage get play => const AssetGenImage('assets/img/common/play.png');
  AssetGenImage get playing =>
      const AssetGenImage('assets/img/common/playing.gif');
  AssetGenImage get qq => const AssetGenImage('assets/img/common/qq.png');
  AssetGenImage get radio => const AssetGenImage('assets/img/common/radio.png');
  AssetGenImage get search =>
      const AssetGenImage('assets/img/common/search.png');
  AssetGenImage get sound => const AssetGenImage('assets/img/common/sound.png');
  AssetGenImage get speech =>
      const AssetGenImage('assets/img/common/speech.png');
  AssetGenImage get vip => const AssetGenImage('assets/img/common/vip.png');
  AssetGenImage get weibo => const AssetGenImage('assets/img/common/weibo.png');
  AssetGenImage get weixin =>
      const AssetGenImage('assets/img/common/weixin.png');
}

class $AssetsImgPlayerGen {
  const $AssetsImgPlayerGen();

  AssetGenImage get phonographHandler =>
      const AssetGenImage('assets/img/player/phonograph_handler.png');
}

class $AssetsMediaLibraryALIEzGen {
  const $AssetsMediaLibraryALIEzGen();

  AssetGenImage get aLIEzJpg =>
      const AssetGenImage('assets/media_library/aLIEz/aLIEz.jpg');
  String get aLIEzLrc => 'assets/media_library/aLIEz/aLIEz.lrc';
  String get aLIEzMp3 => 'assets/media_library/aLIEz/aLIEz.mp3';
}

class $AssetsMediaLibraryForeverYoungGen {
  const $AssetsMediaLibraryForeverYoungGen();

  AssetGenImage get foreverYoungJpg => const AssetGenImage(
      'assets/media_library/forever_young/forever_young.jpg');
  String get foreverYoungLrc =>
      'assets/media_library/forever_young/forever_young.lrc';
  String get foreverYoungMp3 =>
      'assets/media_library/forever_young/forever_young.mp3';
}

class $AssetsMediaLibraryGbqqGen {
  const $AssetsMediaLibraryGbqqGen();

  AssetGenImage get gbqqJpeg =>
      const AssetGenImage('assets/media_library/gbqq/gbqq.jpeg');
  String get gbqqMp3 => 'assets/media_library/gbqq/gbqq.mp3';
  String get qbqq => 'assets/media_library/gbqq/qbqq.lrc';
}

class $AssetsMediaLibraryHavanaGen {
  const $AssetsMediaLibraryHavanaGen();

  AssetGenImage get havanaJpg =>
      const AssetGenImage('assets/media_library/havana/havana.jpg');
  String get havanaLrc => 'assets/media_library/havana/havana.lrc';
  String get havanaMp3 => 'assets/media_library/havana/havana.mp3';
}

class $AssetsMediaLibraryMonsterGen {
  const $AssetsMediaLibraryMonsterGen();

  AssetGenImage get monsterJpg =>
      const AssetGenImage('assets/media_library/monster/monster.jpg');
  String get monsterLrc => 'assets/media_library/monster/monster.lrc';
  String get monsterMp3 => 'assets/media_library/monster/monster.mp3';
}

class Assets {
  Assets._();

  static const $AssetsFontsGen fonts = $AssetsFontsGen();
  static const $AssetsImgGen img = $AssetsImgGen();
  static const $AssetsMediaLibraryGen mediaLibrary = $AssetsMediaLibraryGen();
}

class AssetGenImage extends AssetImage {
  const AssetGenImage(String assetName) : super(assetName);

  Image image({
    Key? key,
    ImageFrameBuilder? frameBuilder,
    ImageLoadingBuilder? loadingBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? width,
    double? height,
    Color? color,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    FilterQuality filterQuality = FilterQuality.low,
  }) {
    return Image(
      key: key,
      image: this,
      frameBuilder: frameBuilder,
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      width: width,
      height: height,
      color: color,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      filterQuality: filterQuality,
    );
  }

  String get path => assetName;
}
