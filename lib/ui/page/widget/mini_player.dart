import 'package:flutter/material.dart';
import 'package:flutter_music/logic/service/audio_player_service.dart';
import 'package:flutter_music/ui/page/page_router.dart';
import 'package:flutter_music/ui/page/share/media_model_builder.dart';
import 'package:flutter_music/ui/page/widget/record.dart';
import 'package:flutter_music/ui/page/widget/seek_bar.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaItemBuilder(builder: (context, mediaItem) {
      if (mediaItem != null) {
        final record = Record(
          radius: 32,
          mediaItem: mediaItem,
        );

        final controller = _Controller();

        final child = Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fromRect(
              rect: Rect.fromCenter(
                center: Offset(
                  32,
                  27,
                ),
                width: 64,
                height: 64,
              ),
              child: record,
            ),
            Positioned(
              left: 84,
              right: 14,
              top: 0,
              bottom: 0,
              child: controller,
            ),
          ],
        );

        return child;
      } else {
        return SizedBox();
      }
    });
  }
}

class _Controller extends StatelessWidget {
  const _Controller({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final info = MediaItemBuilder(
      builder: (context, mediaItem) {
        if (mediaItem != null) {
          return SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: Column(
              children: [
                Text(
                  mediaItem.title,
                  style: TextStyle(color: Colors.white, fontSize: 8.6),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  mediaItem.artist ?? '佚名',
                  style: TextStyle(color: Colors.grey, fontSize: 7.2),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              //mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );

    final iconSize = 16.0;
    final splashRadius = 20.0;

    final playButton = StreamBuilder<bool>(
      stream: AudioPlayerService.instance.playingStream,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!) {
          return IconButton(
            onPressed: () {
              AudioPlayerService.instance.pause();
            },
            splashRadius: splashRadius,
            icon: Icon(
              Icons.pause,
              size: iconSize,
              color: Colors.white,
            ),
          );
        } else {
          return IconButton(
            onPressed: () {
              AudioPlayerService.instance.play();
            },
            splashRadius: splashRadius,
            icon: Icon(
              Icons.play_arrow,
              size: iconSize,
              color: Colors.white,
            ),
          );
        }
      },
    );

    final controls = Row(
      children: [
        playButton,
        IconButton(
          onPressed: () {
            AudioPlayerService.instance.pause();
          },
          splashRadius: splashRadius,
          icon: Icon(
            Icons.skip_next,
            size: iconSize,
            color: Colors.white,
          ),
        ),
        IconButton(
          onPressed: () {
            AudioPlayerService.instance.play();
          },
          splashRadius: splashRadius,
          icon: Icon(
            Icons.menu,
            size: iconSize,
            color: Colors.white,
          ),
        )
      ],
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    );

    final result = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 15,
        ),
        SeekBar(
          activeColor: const Color(0xFF2190f3),
          inactiveColor: const Color(0xFF01182d),
          thumbColor: const Color(0xFF2190f3),
          height: 1.0,
          factor: 4.0,
        ),
        Expanded(
          child: Row(
            children: [
              const SizedBox(width: 5.0),
              info,
              Expanded(
                child: Container(
                  child: controls,
                  //color: Colors.blue.withOpacity(0.15),
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceAround,
          ),
        ),
      ],
    );

    return Container(
      //color: Colors.red.withOpacity(0.15),
      child: result,
    );
  }
}
