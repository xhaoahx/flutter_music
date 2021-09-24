import 'package:provider/provider.dart';
import 'dart:ui' as ui;
import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music/logic/model/player_model.dart';
import 'package:flutter_music/ui/page/player/lyric_viewer.dart';
import 'package:flutter_music/ui/page/share/media_model_builder.dart';
import 'package:marquee/marquee.dart';

import 'controller.dart';
import 'background.dart';
import 'phonograph.dart';

class Player extends StatefulWidget {
  const Player({Key? key}) : super(key: key);

  static const routeName = 'player';
  static Widget builder(BuildContext context) => Player();

  @override
  _PlayerState createState() => _PlayerState();

  static _PlayerState? of(BuildContext context) =>
      context.findAncestorStateOfType<_PlayerState>();
}

class _PlayerState extends State<Player> with TickerProviderStateMixin<Player> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final foreground = Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: primaryColor,
          ),
          splashRadius: 20.0,
          // TODO: implements onpressed
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: _Header(),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: OrientationBuilder(builder: (context, orientation) {
              switch (orientation) {
                case Orientation.landscape:
                  return ContentLandscape();
                case Orientation.portrait:
                default:
                  return ContentPortrait();
              }
            }),
          ),
          PlayerController(),
        ],
      ),
    );

    final filter = BackdropFilter(
      filter: ui.ImageFilter.blur(
        sigmaX: 33.0,
        sigmaY: 33.0,
      ),
      child: Align(
        alignment: Alignment.center,
      ),
    );

    final background = Background();

    return Stack(
      fit: StackFit.expand,
      children: [
        background,
        filter,
        foreground,
      ],
    );
  }
}

class ContentLandscape extends StatelessWidget {
  const ContentLandscape({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lyric = LyricViewer();
    final phonograph = Phonograph();
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.height * 0.5625,
          child: phonograph,
        ),
        Expanded(
          child: lyric,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.height * 0.5625,
          //child: phonograph,
        ),
      ],
    );
  }
}

class ContentPortrait extends StatefulWidget {
  const ContentPortrait({Key? key}) : super(key: key);

  @override
  _ContentPortraitState createState() => _ContentPortraitState();
}

class _ContentPortraitState extends State<ContentPortrait> {
  bool _showLyric = false;

  @override
  Widget build(BuildContext context) {
    final lyric = LyricViewer();
    final phonograph = Phonograph();

    final child = AnimatedSwitcher(
      duration: const Duration(milliseconds: 450),
      switchInCurve: Curves.easeIn,
      child: _showLyric ? lyric : phonograph,
    );

    print('rebuild content');

    return StreamBuilder<PlayerEvent>(
      stream: context.read<PlayerModel>().eventStream,
      builder: (context, snapshot) {
        return GestureDetector(
          onTap: (snapshot.hasData && snapshot.data! is ShiftingStartEvent)
              ? null
              : () {
                  setState(() {
                    _showLyric = !_showLyric;
                  });
                },
          child: child,
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaItemBuilder(
      builder: (context, mediaItem) {
        final title = mediaItem?.title ?? 'unknown';
        final artist = mediaItem?.artist ?? 'unknown';
        final titleStyle = TextStyle(
          fontSize: 18.0,
          color: primaryColor,
          fontWeight: FontWeight.w400,
        );
        final artistStyle = TextStyle(
          fontSize: 14.0,
          color: accentColor,
        );

        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: 24.0,
              width: 128.0,
              child: title.length < 8
                  ? Text(
                      title,
                      style: titleStyle,
                      textAlign: TextAlign.center,
                    )
                  : Marquee(
                      text: title,
                      style: titleStyle,
                      pauseAfterRound: const Duration(milliseconds: 1200),
                      crossAxisAlignment: CrossAxisAlignment.center,
                      blankSpace: 80.0,
                    ),
            ),
            Text(
              artist,
              style: artistStyle,
              textAlign: TextAlign.center,
            ),
          ],
        );
      },
    );
  }
}
