import 'dart:async';
import 'dart:ui';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music/logic/service/audio_player_service.dart';
import 'package:flutter_music/ui/page/page_router.dart';
import 'package:flutter_music/ui/page/widget/mini_player.dart';

class Index extends StatefulWidget {
  const Index({Key? key}) : super(key: key);

  static const routeName = 'index';
  static Widget builder(BuildContext context) => Index();

  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  late final PageController _pageController;
  static final GlobalKey<__MiniPlayerWrapperState> _wrapperKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // mini player
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      Overlay.of(context)?.insert(
        OverlayEntry(
          builder: (context) => _MiniPlayerWrapper(
            key: _wrapperKey,
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final background = Image.asset(
      'assets/img/common/bg2.jpg',
      fit: BoxFit.fill,
    );
    final body = Column(
      children: [
        _Header(),
        Expanded(
          child: PageView(
            children: List.generate(
              3,
              (index) => _PageView(),
            ),
            controller: _pageController,
          ),
        ),
      ],
      mainAxisSize: MainAxisSize.min,
    );

    final index =  Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: background),
          Positioned.fill(
            child: SafeArea(
              child: body,
            ),
          ),
        ],
      ),
    );

    return WillPopScope(child: index, onWillPop:() async => false);
  }
}

class _Header extends StatelessWidget {
  const _Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    final menu = SizedBox(
      width: w * 0.05,
      height: w * 0.05,
      child: Image.asset('assets/img/common/hamburger.png'),
    );

    final search = SizedBox(
      width: w * 0.05,
      height: w * 0.05,
      child: Image.asset('assets/img/common/search.png'),
    );

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: w * 0.052,
        vertical: 0,
      ),
      height: h * 0.079,
      child: Row(
        children: [
          menu,
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: w * 0.159,
            ),
            child: SizedBox(
              width: w * 0.478,
              child: _PageIndicator(),
            ),
          ),
          search,
        ],
      ),
    );
  }
}

class _PageIndicator extends StatefulWidget {
  const _PageIndicator({Key? key}) : super(key: key);

  @override
  __PageIndicatorState createState() => __PageIndicatorState();
}

class __PageIndicatorState extends State<_PageIndicator> {
  final _colorBeginTween =
      ColorTween(begin: const Color(0xFF0676df), end: Colors.white);
  final _colorEndTween =
      ColorTween(begin: const Color(0xFF0676df), end: const Color(0xFF47d6eb));
  final _fontSizeTween = Tween<double>(begin: 17.52, end: 22.8);

  static const _titles = <String>['听', '看', '唱'];

  double _page = 0.0;

  @override
  void initState() {
    super.initState();

    final controller =
        context.findAncestorStateOfType<_IndexState>()!._pageController;
    controller.addListener(() => _handlePageChanged(controller));
  }

  void _handlePageChanged(PageController controller) {
    setState(() {
      _page = controller.page!;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    Widget _buildTitle(int index) {
      final percent = 1.0 - (_page - index).abs().clamp(0.0, 1.0);

      final color = _colorBeginTween.lerp(percent)!;
      final gradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color,
          color,
          color,
          _colorEndTween.lerp(percent)!,
        ],
      );

      return GestureDetector(
        child: Builder(
          builder: (context) {
            return Text(
              _titles[index],
              style: TextStyle(
                foreground: Paint()
                  ..shader = gradient.createShader(
                    Rect.fromLTWH(
                      0,
                      MediaQuery.of(context).systemGestureInsets.top,
                      w,
                      h * 0.093,
                    ),
                  ),
                fontSize: _fontSizeTween.lerp(percent),
              ),
            );
          },
        ),
        onTap: () => _handleTap(index),
      );
    }

    final row = List.generate(
      _titles.length,
      (index) => _buildTitle(index),
    );

    final span = 0.149 * w;
    final dw = 0.06 * w;

    return Stack(
      children: [
        Positioned.fill(
          child: Row(
            children: row,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
        ),
        Positioned(
          left: (span + dw) * _page,
          top: 0.079 * h - 1.5,
          child: Container(
            height: 1.5,
            width: dw,
            color: const Color(0xFF0676df),
          ),
        )
      ],
    );
  }

  void _handleTap(int index) {
    final controller =
        context.findAncestorStateOfType<_IndexState>()!._pageController;
    controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeIn,
    );
  }
}

class _UserInfo extends StatelessWidget {
  const _UserInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final avatar = Container(
      margin: const EdgeInsets.fromLTRB(22.47, 9.52, 16.38, 9.52),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Image.asset(
          'assets/img/common/avatar.png',
          fit: BoxFit.fill,
        ),
      ),
    );

    final info = Column(
      children: [
        Row(
          children: [
            Text(
              '胡萝北',
              style: TextStyle(
                  fontSize: 10.0, color: Colors.white, letterSpacing: 3.4),
              textAlign: TextAlign.start,
            ),
            Container(
              margin: EdgeInsets.only(
                left: 7.61,
              ),
              width: 9.14,
              height: 9.14,
              child: Image.asset(
                'assets/img/common/vip.png',
                fit: BoxFit.cover,
              ),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.start,
        ),
        const SizedBox(
          height: 7.8,
        ),
        Row(
          children: [
            Container(
              margin: EdgeInsets.only(right: 6.85, left: 2.4),
              width: 20.0,
              height: 10.0,
              alignment: Alignment.center,
              child: Text(
                'LV.5',
                style: TextStyle(
                  fontSize: 8.0,
                  color: Colors.orange,
                ),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.5),
                border: Border.all(color: Colors.orange, width: 1.0),
              ),
            ),
            Text(
              '听歌15302分钟',
              style: TextStyle(fontSize: 6.0, color: Colors.grey),
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
    );

    final email = Padding(
      padding: EdgeInsets.only(right: 43.04),
      child: SizedBox(
        width: 20.57,
        height: 20.57,
        child: Image.asset('assets/img/common/email.png'),
      ),
    );

    return Container(
      child: Row(
        children: [
          avatar,
          Expanded(child: info),
          email,
        ],
        mainAxisAlignment: MainAxisAlignment.start,
      ),
    );
  }
}

class _Items extends StatelessWidget {
  const _Items({Key? key}) : super(key: key);

  static const _path = [
    'assets/img/common/pc.png',
    'assets/img/common/heart.png',
    'assets/img/common/download.png',
    'assets/img/common/clock.png',
  ];

  static const _titles = [
    '本地音乐',
    '喜欢·歌单',
    '下载',
    '最近',
  ];

  static const _count = [
    '148',
    '3',
    '2',
    '100',
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(_path.length, (index) {
        return Column(
          children: [
            SizedBox(
              height: 29.714,
              width: 34.28,
              child: Image.asset(
                _path[index],
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 16.76),
            Text(
              _titles[index],
              style: TextStyle(color: Colors.white, fontSize: 12.57),
            ),
            const SizedBox(
              height: 9.9,
            ),
            Text(
              _count[index],
              style: TextStyle(color: Colors.grey, fontSize: 8),
            )
          ],
        );
      }),
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    );
  }
}

class _Menus extends StatelessWidget {
  const _Menus({Key? key}) : super(key: key);

  static const _colors = [
    Color(0xFF06b062),
    Color(0xFF067ab0),
    Color(0xFFe62134),
    Color(0xFFc25bd1),
    Color(0xFFedb231),
    Color(0xFF4be22d),
  ];

  static const _path = [
    'assets/img/common/lib.png',
    'assets/img/common/list.png',
    'assets/img/common/chart.png',
    'assets/img/common/radio.png',
    'assets/img/common/calendar.png',
    'assets/img/common/speech.png',
  ];

  static const _title = [
    '乐库',
    '歌单',
    '电台·酷群',
    '猜你喜欢',
    '每日推荐',
    '听歌识曲',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        // vertical: 10.8,
        horizontal: 36.57,
      ),
      child: GridView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(0),
        children: List.generate(_path.length, (index) {
          final child = SizedBox(
            width: 62.85,
            child: Column(
              children: [
                Container(
                  width: 62.85,
                  height: 62.85,
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 24.09,
                    height: 32.9,
                    child: Image.asset(
                      _path[index],
                      fit: BoxFit.contain,
                      alignment: Alignment.center,
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: _colors[index],
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(height: 12.19),
                Text(
                  _title[index],
                  style: TextStyle(
                    color: const Color(0xFF87cbcc),
                    fontSize: 11.4,
                  ),
                )
              ],
            ),
          );

          return MaterialButton(
            onPressed: () {
              Navigator.of(context).pushNamed(PageRouter.play_list);
            },
            child: child,
          );
        }),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, childAspectRatio: 1),
      ),
    );
  }
}

class _Promote extends StatelessWidget {
  const _Promote({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sound = Padding(
      padding: const EdgeInsets.only(right: 0),
      child: SizedBox(
        width: 60.0,
        height: 60.0,
        child: Image.asset('assets/img/common/sound.png'),
      ),
    );

    final text = Text(
      '推广',
      style: TextStyle(
        fontSize: 13,
        color: Color(0xFF87cbcc),
      ),
    );

    final promote = Text(
      '装了这个ＡＰＰ，不用再去ＫＴＶ',
      style: TextStyle(
        fontSize: 9.5,
        color: Color(0xFF87cbcc),
        letterSpacing: 2.3,
      ),
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 26.28),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [sound, text],
              mainAxisAlignment: MainAxisAlignment.start,
            ),
          ),
          promote,
        ],
      ),
      height: 54.8,
    );
  }
}

class _PageView extends StatelessWidget {
  const _PageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;

    return Column(
      children: [
        _UserInfo(),
        SizedBox(height: h * 0.024),
        _Items(),
        SizedBox(height: h * 0.018),
        _Menus(),
        _Promote(),
        //Text('dasda'),
      ],
    );
  }
}

class _MiniPlayerWrapper extends StatefulWidget {
  const _MiniPlayerWrapper({Key? key}) : super(key: key);

  @override
  __MiniPlayerWrapperState createState() => __MiniPlayerWrapperState();
}

class __MiniPlayerWrapperState extends State<_MiniPlayerWrapper> {
  bool _shouldShow = true;
  bool _hasMedia = false;
  late final StreamSubscription _queueSub;

  @override
  void initState() {
    super.initState();
    _queueSub = AudioPlayerService.instance.mediaItem.listen(_handleQueueState);
  }

  @override
  void dispose() {
    _queueSub.cancel();
    super.dispose();
  }

  void _handleQueueState(MediaItem? mediaItem) {
    print('receivew Media: $mediaItem');
    if (mediaItem != null) {
      setState(() {
        _hasMedia = true;
      });
    } else {
      setState(() {
        _hasMedia = false;
      });
    }
  }

  void _show() {
    setState(() => _shouldShow = true);
    print('show');
  }

  void _hide() {
    setState(() => _shouldShow = false);
    print('hide');
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final child = Offstage(
      child: MaterialButton(
        key: ValueKey<bool>(_shouldShow && _hasMedia),
        onPressed: () async {
          _hide();
          await Navigator.of(context).pushNamed(PageRouter.player);
          _show();
        },
        child: MiniPlayer(),
        color: const Color(0xFF151f28),
      ),
      offstage: !(_shouldShow && _hasMedia),
    );

    return AnimatedPositioned.fromRect(
      child: child,
      rect: Rect.fromLTWH(
        0,
        (_shouldShow && _hasMedia) ? h - 64 : h,
        w,
        64,
      ),
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeIn,
    );
  }
}
