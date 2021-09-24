import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_music/generated/l10n.dart';
import 'package:flutter_music/logic/object/media_library.dart';
import 'package:flutter_music/logic/service/audio_player_service.dart';
import 'package:flutter_music/logic/model/i18n_model.dart';
import 'package:flutter_music/logic/model/theme_model.dart';
import 'package:flutter_music/ui/config/locale.dart';
import 'package:flutter_music/ui/page/page_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_music/ui/tool/screen_tool.dart';
import 'package:provider/provider.dart';

import 'logic/model/player_model.dart';

class FlutterMusic extends StatelessWidget {
  const FlutterMusic({Key? key}) : super(key: key);

  static final _themeModel = ThemeModel();
  static final _i18nModel = I18nModel();
  static final _playerModel = PlayerModel();

  static Future<void> initialize() async {
    print('initialized start');
    WidgetsFlutterBinding.ensureInitialized();
    await Future.wait([
      ScreenTool.initialize(),
      MediaLibrary.initialize(),
      FlutterMusic._themeModel.initialize(),
      FlutterMusic._i18nModel.initialize(),
      AudioPlayerService.initialize(),
    ]);

    if (!kIsWeb) {
      if (Platform.isAndroid) {
        SystemUiOverlayStyle systemUiOverlayStyle =
            SystemUiOverlayStyle(statusBarColor: Colors.transparent);
        SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
      }

      // On phone, set portrait force
      if (!ScreenTool.instance.originalIsLandscape) {
        ScreenTool.instance.setPortraitForce();
      }
    }

    print('initialized end');
    assert(ServicesBinding.instance != null);
  }

  @override
  Widget build(BuildContext context) {
    final app = Builder(
      builder: (context) => MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          S.delegate,
        ],
        locale: LocaleConfig.localeOf(context.watch<I18nModel>().current),
        supportedLocales: LocaleConfig.values,
        theme: ThemeConfig.themeOf(context.watch<ThemeModel>().current),
        onGenerateTitle: _handleGenerateTitle,
        onGenerateRoute: PageRouter.handleGenerateRoute,
        initialRoute: PageRouter.handleInitialRouteDependsPlatform(),
      ),
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _themeModel),
        ChangeNotifierProvider.value(value: _i18nModel),
        ChangeNotifierProvider.value(value: _playerModel),
      ],
      child: app,
    );
  }

  String _handleGenerateTitle(BuildContext context) => S.of(context).kugouMusic;
}
