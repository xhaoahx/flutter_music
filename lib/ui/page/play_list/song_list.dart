import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music/logic/object/media_library.dart';
import 'package:flutter_music/logic/service/audio_player_service.dart';
import 'package:flutter_music/ui/page/share/media_model_builder.dart';

class SongList extends StatefulWidget {
  const SongList({Key? key}) : super(key: key);

  @override
  _SongListState createState() => _SongListState();
}

class _SongListState extends State<SongList> {
  @override
  Widget build(BuildContext context) {
    final mediaList = MediaLibrary.instance.mediaList;

    return ListView.separated(
        itemBuilder: (context, index) {
          return _ListItem(mediaItem: mediaList[index]);
        },
        itemCount: mediaList.length,
        separatorBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 42),
              child: Image.asset(
                'assets/img/common/divider.png',
                fit: BoxFit.fitWidth,
              ),
            ));
  }
}

class _ListItem extends StatelessWidget {
  const _ListItem({
    Key? key,
    required this.mediaItem,
  }) : super(key: key);

  final MediaItem mediaItem;

  @override
  Widget build(BuildContext context) {
    return MediaItemBuilder(
      builder: (context, current) {
        late final Widget? leading;
        late final Widget? trailing;

        if (current != null && current.id == mediaItem.id) {
          leading = StreamBuilder<bool>(
            stream: AudioPlayerService.instance.playingStream,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!) {
                return IconButton(
                  onPressed: () {
                    print('play');
                    AudioPlayerService.instance.pause();
                  },
                  icon: Icon(
                    Icons.pause,
                    color: Colors.white,
                  ),
                );
              } else {
                return IconButton(
                  onPressed: () {
                    print('pause');
                    AudioPlayerService.instance.play();
                  },
                  icon: Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                  ),
                );
              }
            },
          );

          trailing = StreamBuilder<bool>(
            stream: AudioPlayerService.instance.playingStream,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!) {
                return Image.asset(
                  'assets/img/common/playing.gif',
                  fit: BoxFit.contain,
                );
              } else {
                return const SizedBox();
              }
            },
          );
        } else {
          leading = IconButton(
            onPressed: () async {
              print('tapped: ${mediaItem.id}');
              final service = AudioPlayerService.instance;

              final idList =
                  service.queue.valueOrNull?.map((e) => e.id).toList() ?? [];

              print(idList);

              if (idList.contains(mediaItem.id)) {
                await service.skipToQueueItem(idList.indexOf(mediaItem.id));
              } else {
                await service.insertQueueItem(0, mediaItem);
                await service.skipToQueueItem(0);
              }

              AudioPlayerService.instance.play();
            },
            icon: Icon(
              Icons.play_arrow,
              color: Colors.white,
            ),
          );
          trailing = null;
        }

        final listTile = ListTile(
          minVerticalPadding: 4.0,
          leading: SizedBox(
            width: 43.8,
            height: 43.8,
            child: leading,
          ),
          title: Text(
            mediaItem.title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.3,
              letterSpacing: 2,
            ),
          ),
          subtitle: Text(
            mediaItem.artist ?? '佚名',
            style: TextStyle(
              color: Colors.white,
              fontSize: 9,
            ),
          ),
          trailing: SizedBox(
            width: 20,
            height: 20,
            child: trailing,
          ),
        );

        return Container(
          child: listTile,
          height: 102.8,
          alignment: Alignment.center,
        );
      },
    );
  }
}
