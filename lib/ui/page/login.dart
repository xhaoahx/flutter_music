import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  static const routeName = '/';
  static Widget builder(BuildContext context) => Login();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    print(MediaQuery.of(context).devicePixelRatio);

    final background = Image.asset(
      'assets/img/common/bg1.jpg',
      fit: BoxFit.fill,
    );

    final close = Image.asset(
      'assets/img/common/close.png',
      fit: BoxFit.cover,
    );

    final header = Row(
      children: [
        SizedBox(
          child: Image.asset(
            'assets/img/common/logo.png',
            fit: BoxFit.cover,
          ),
          width: 66.28,
          height: 66.28,
        ),
        Column(
          children: [
            Text(
              '酷狗音乐',
              style: TextStyle(
                color: Colors.white,
                fontSize: 34,
                letterSpacing: 12.95,
              ),
            ),
            //const SizedBox(height: 11.04),
            Text(
              '音乐总有新玩法',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                letterSpacing: 13.33,
              ),
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
        )
      ],
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
    );

    final loginBtn = _Btn(
      onPressed: () => _handleLogin(context),
      text: '登录',
      color: Color.fromARGB(255, 12, 150, 230),
    );

    final registerBtn = _Btn(
      onPressed: _handleRegister,
      text: '注册',
      color: Color.fromARGB(255, 12, 230, 197),
    );

    final otherLogin = _OtherLogin();

    final fontColor = Color.fromARGB(255, 4, 150, 234);

    final agreement = Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '登录代表你同意',
            style: TextStyle(color: Colors.white),
          ),
          TextSpan(
            text: '酷狗服务',
            style: TextStyle(color: fontColor),
          ),
          TextSpan(
            text: '和',
            style: TextStyle(color: Colors.white),
          ),
          TextSpan(
            text: '隐私条款',
            style: TextStyle(color: fontColor),
          ),
        ],
      ),
      style: TextStyle(fontSize: 10.66, letterSpacing: 3.0),
    );

    final loginBlock = Column(
      children: [
        Column(
          children: [
            loginBtn,
            const SizedBox(height: 15.83),
            registerBtn,
          ],
        ),
        SizedBox(height: h * 0.059),
        otherLogin,
        SizedBox(height: h * 0.03),
        agreement,
      ],
    );

    final body = Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 71.24,
            vertical: h * 0.2,
          ),
          child: header,
        ),
        //SizedBox(height: h * 0.286),
        loginBlock,
      ],
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    );

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: background),
          Positioned.fromRect(
            rect: Rect.fromLTWH(w * 0.051, h * 0.063, 17.14, 17.14),
            child: close,
          ),
          Positioned.fill(
            child: Center(
              child: body,
            ),
          ),
        ],
      ),
    );
  }

  void _handleLogin(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('index');
  }

  void _handleRegister() {}
}

class _Btn extends StatelessWidget {
  const _Btn({
    Key? key,
    required this.onPressed,
    required this.text,
    required this.color,
  }) : super(key: key);

  final String text;
  final VoidCallback onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return SizedBox(
      width: w * 0.6898,
      height: 40.76,
      child: MaterialButton(
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.38),
        ),
        color: color,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            letterSpacing: 4.5,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _OtherLogin extends StatelessWidget {
  const _OtherLogin({Key? key}) : super(key: key);

  static final _iconPaths = [
    'assets/img/common/weibo.png',
    'assets/img/common/qq.png',
    'assets/img/common/weixin.png'
  ];
  static final _titles = [
    '微博',
    'QQ',
    '微信',
  ];

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    final part = Container(
      color: Colors.white,
      height: 0.75,
      width: w * 0.271,
      padding: const EdgeInsets.symmetric(horizontal: 7.6),
    );

    final divider = Row(
      children: [
        part,
        Text(
          '其他登录方式',
          style: TextStyle(
            color: Colors.white,
            fontSize: 11.8,
            letterSpacing: 3.42,
          ),
        ),
        part,
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    );

    final choices = Row(
      children: List.generate(_iconPaths.length, (index) {
        return Column(
          children: [
            SizedBox(
              height: 24.76,
              width: 24.76,
              child: Image.asset(_iconPaths[index]),
            ),
            const SizedBox(height: 11.8),
            Text(
              _titles[index],
              style: TextStyle(
                fontSize: 10,
                letterSpacing: 2,
                color: Colors.white,
              ),
            ),
          ],
        );
      }),
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    );

    return Container(
      child: Column(
        children: [
          divider,
          const SizedBox(height: 32.76),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.21),
            child: choices,
          ),
          const SizedBox(height: 28.19),
        ],
      ),
    );
  }
}
