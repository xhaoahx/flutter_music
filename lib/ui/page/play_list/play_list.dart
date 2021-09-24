import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'song_list.dart';

class PlayList extends StatefulWidget {
  static const routeName = 'play_list';
  static Widget builder(BuildContext context) => PlayList();

  const PlayList({Key? key}) : super(key: key);

  @override
  _PlayListState createState() => _PlayListState();
}

class _PlayListState extends State<PlayList> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
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

    final divider = Image.asset(
      'assets/img/common/divider.png',
      fit: BoxFit.fitWidth,
    );

    final body = SafeArea(
      child: Center(
        child: Column(
          children: [
            _Header(),
            const SizedBox(
              height: 52,
            ),
            _PageIndicator(),
            divider,
            Expanded(child: _PageView()),
          ],
        ),
      ),
    );

    return Scaffold(
        body: Stack(
      children: [
        Positioned.fill(child: background),
        Positioned.fill(child: body),
      ],
    ));
  }
}

class _Header extends StatelessWidget {
  const _Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final search = SizedBox(
      width: 17.9,
      height: 17.9,
      child: Image.asset(
        'assets/img/common/search.png',
        fit: BoxFit.contain,
      ),
    );

    final title = Text(
      '最近',
      style: TextStyle(
        color: Colors.white,
        fontSize: 15.2,
      ),
    );

    final menu = SizedBox(
      width: 17.9,
      height: 17.9,
      child: Image.asset(
        'assets/img/common/hamburger.png',
        fit: BoxFit.contain,
      ),
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.9),
      child: Row(
        children: [search, title, menu],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
  double _currentPage = 0;

  static final _colorTween = ColorTween(
    begin: const Color(0xFFa6a7ac),
    end: Colors.white,
  );

  static const _titles = [
    '单曲',
    '专辑',
    '详情',
    '歌词',
    '歌词本',
  ];

  @override
  void initState() {
    super.initState();

    final controller =
        context.findAncestorStateOfType<_PlayListState>()!._pageController;
    controller.addListener(() {
      setState(() {
        _currentPage = controller.page!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final row = Row(
      children: List.generate(5, (index) {
        final percent = 1.0 - (index - _currentPage).abs().clamp(0.0, 1.0);

        final child = Text(
          _titles[index],
          style: TextStyle(
            color: _colorTween.lerp(percent)!,
            fontSize: 16.38,
          ),
        );

        return SizedBox(
          child: MaterialButton(
            onPressed: () {
              final controller = context
                  .findAncestorStateOfType<_PlayListState>()!
                  ._pageController;

              if ((index - _currentPage).abs() > 1) {
                controller.jumpToPage(index);
              } else {
                controller.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 320),
                  curve: Curves.easeIn,
                );
              }
            },
            child: child,
            padding: const EdgeInsets.all(0),
          ),
          width: (MediaQuery.of(context).size.width - 60.8) / 5,
        );
      }),
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.4),
      child: row,
    );
  }
}

class _PageView extends StatelessWidget {
  const _PageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller:
          context.findAncestorStateOfType<_PlayListState>()!._pageController,
      children: [
        SongList(),
        ...List.generate(
          4,
          (index) => Container(
            child: Text('Unimplemented'),
          ),
        ),
      ],
    );
  }
}
