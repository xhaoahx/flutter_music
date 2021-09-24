import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter_music/logic/model/player_model.dart';
import 'package:flutter_music/logic/object/lyric.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_music/ui/page/share/media_model_builder.dart';

final _preViewColor = Colors.white.withOpacity(0.5);

class LyricViewer extends StatelessWidget {
  const LyricViewer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaItemBuilder(
      builder: (context, mediaItem) {
        final lyricList = context.select<PlayerModel, List<Lyric>?>(
          (model) => model.lyricList,
        );

        if (mediaItem == null || lyricList == null) {
          return SizedBox(
            child: Center(),
          );
        }

        return _LyricViewer(lyricList: lyricList);
      },
    );
  }
}

class _LyricViewer extends StatefulWidget {
  const _LyricViewer({
    Key? key,
    required this.lyricList,
  }) : super(key: key);

  final List<Lyric> lyricList;

  @override
  __LyricViewerState createState() => __LyricViewerState();
}

class __LyricViewerState extends State<_LyricViewer> {
  late final ScrollController _scrollController;
  late final StreamSubscription<int> _lyricSub;

  late int _lastIndex;
  late int _currentIndex;
  late int _previewIndex;

  double _paddingHeight = 0.0;
  _LyricScrollingData? _lyricScrollingData;

  final GlobalKey _columnKey = GlobalKey(debugLabel: 'column');
  static const _itemHeight = 56.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_updatePreviewIndex);

    final model = context.read<PlayerModel>();

    _lyricSub = model.lyricIndexStream.listen(_updateLyricIndex);

    // init
    _currentIndex = model.currentLyricIndex;
    _lastIndex = _currentIndex;
    _previewIndex = _currentIndex;
    _createScrollData(widget.lyricList.length);

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _updateLyricIndex(_currentIndex, true);
    });
  }

  void _createScrollData(int length) {
    if (_lyricScrollingData != null) {
      _lyricScrollingData = null;
    }
    assert(_lyricScrollingData == null);

    _lyricScrollingData = _LyricScrollingData(length);
    _lyricScrollingData!.markShouldCalculate(_columnKey);
  }

  @override
  void dispose() {
    _lyricSub.cancel();
    _scrollController.dispose();

    super.dispose();
  }

  void _updateLyricIndex(int index, [bool jump = false]) {
    if (index == -1) return;

    _currentIndex = index;
    if (_scrollController.hasClients) {
      final activity = _scrollController.position.activity;
      if (activity is HoldScrollActivity ||
          activity is DragScrollActivity ||
          activity is BallisticScrollActivity) {
        return;
      }

      final globalKeys = _lyricScrollingData!._globalKeys;
      final delta = (_currentIndex - _lastIndex + 2).abs().clamp(2, 0x7FFFFFFF);

      final irb = globalKeys[_currentIndex].currentContext!.findRenderObject()
          as RenderBox;
      final crb = _columnKey.currentContext!.findRenderObject() as RenderBox;
      final offset = irb.localToGlobal(Offset.zero, ancestor: crb);

      globalKeys[_lastIndex].currentState!.setCurrent(false);
      globalKeys[_currentIndex].currentState!.setCurrent(true);
      if(_previewIndex == _lastIndex){
        globalKeys[_lastIndex].currentState!.setPreview(false);
        globalKeys[_currentIndex].currentState!.setPreview(true);
      }
      if (jump) {
        _scrollController.jumpTo(offset.dy);
      } else {
        _scrollController.animateTo(
          offset.dy,
          duration: Duration(
            milliseconds: (200 * math.log(delta)).toInt(),
          ),
          curve: Curves.easeIn,
        );
      }
    }

    _lastIndex = _currentIndex;
  }

  void _updatePreviewIndex() async {
    if (_scrollController.hasClients) {
      final offset = _scrollController.offset;

      for (var i = 0; i < widget.lyricList.length - 1; i += 1) {
        if (offset >= _lyricScrollingData!._offsetList[i] &&
            offset < _lyricScrollingData!._offsetList[i + 1]) {
          if (i != _previewIndex) {
            final globalKeys = _lyricScrollingData!._globalKeys;

            globalKeys[_previewIndex].currentState!.setPreview(false);
            globalKeys[i].currentState!.setPreview(true);
            setState(() {
              _previewIndex = i;
            });
            break;
          }
        }
      }
    } else {
      _previewIndex = 0;
    }
  }

  @override
  void didUpdateWidget(covariant _LyricViewer oldWidget) {
    _createScrollData(widget.lyricList.length);

    _currentIndex = 0;
    _lastIndex = 0;
    _previewIndex = 0;
    _scrollController.jumpTo(0);

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _paddingHeight = constraints.maxHeight * 0.5 - _itemHeight * 0.5;

        final lyricList = widget.lyricList;

        final padding = SliverToBoxAdapter(
          child: SizedBox(
            height: _paddingHeight,
          ),
        );

        final children = List.generate(
          lyricList.length,
          (index) {
            return _LyricItem(
              key: _lyricScrollingData!._globalKeys[index],
              lyric: lyricList[index].content,
              index: index,
            );
          },
        );

        return CustomScrollView(
          controller: _scrollController,
          slivers: [
            padding,
            SliverToBoxAdapter(
              child: Column(
                key: _columnKey,
                children: children,
                mainAxisSize: MainAxisSize.min,
              ),
            ),
            padding,
          ],
        );
      },
    );
  }
}

class _LyricItem extends StatefulWidget {
  const _LyricItem({
    Key? key,
    required this.lyric,
    required this.index,
  }) : super(key: key);

  final int index;
  final String lyric;

  @override
  __LyricItemState createState() => __LyricItemState();
}

class __LyricItemState extends State<_LyricItem> {
  bool _current = false;
  bool _preview = false;

  void setCurrent(bool value) => setState(() => _current = value);
  void setPreview(bool value) => setState(() => _preview = value);

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: _LyricViewerState._itemHeight,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(
        horizontal: 32.0,
        vertical: 15.0,
      ),
      child: Text(
        widget.lyric,
        style: TextStyle(
          color: _color,
          fontSize: 18.0,
          fontWeight: FontWeight.w400,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Color get _color {
    if (_current) return primaryColor;
    if (_preview) return _preViewColor;
    return accentColor;
  }
}

class _LyricScrollingData {
  _LyricScrollingData(int length)
      : _globalKeys = List.generate(
          length,
          (index) => GlobalKey<__LyricItemState>(debugLabel: '$index'),
        ),
        _offsetList = List.generate(length, (index) => 0);

  final List<GlobalKey<__LyricItemState>> _globalKeys;
  final List<double> _offsetList;

  bool _calculated = false;
  bool get calculated => _calculated;
  bool _marked = false;

  void _calculateOffset(RenderBox parent) {
    if (_calculated) return;

    for (int i = 0; i < _globalKeys.length; i++) {
      _offsetList[i] =
          (_globalKeys[i].currentContext!.findRenderObject() as RenderBox)
              .localToGlobal(Offset.zero, ancestor: parent)
              .dy;
    }
    _calculated = true;
  }

  void markShouldCalculate(GlobalKey key) {
    if (!_marked) {
      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
        _calculateOffset(key.currentContext!.findRenderObject() as RenderBox);
      });
    }
    _marked = true;
  }
}
