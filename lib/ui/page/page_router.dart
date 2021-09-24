import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music/ui/page/play_list/play_list.dart';
import 'package:flutter_music/ui/page/player/player.dart';
import 'package:flutter_music/ui/page/widget/fade_in_page_route.dart';
import 'login.dart';
import 'index.dart';

class PageRouter {
  static const _unknownRouteName = 'unknown';

  //static const splash = Splash.routeName;
  //static const navigation = Navigation.routeName;
  static const player = Player.routeName;
  static const login = Login.routeName;
  static const index = Index.routeName;
  static const play_list = PlayList.routeName;

  static Map<String, WidgetBuilder> _routeTable = {
    //splash: Splash.builder,
    //navigation: Navigation.builder,
    player: Player.builder,
    login: Login.builder,
    index: Index.builder,
    play_list: PlayList.builder,
  };

  static Route<dynamic>? handleGenerateRoute(RouteSettings settings) {
    final routeName = settings.name ?? _unknownRouteName;
    final builder = _routeTable[routeName];

    assert(builder != null, 'Unhandled null route builder');

    late Route route;
    switch (routeName) {
      //case navigation:
      case index:
        route = FadeInPageRoute(builder: builder!);
        break;
      default:
        route = MaterialPageRoute(builder: builder!);
    }
    return route;
  }

  static String handleInitialRouteDependsPlatform() {
    if (kIsWeb || Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      return index;
    } else {
      return login;
    }
  }
}
