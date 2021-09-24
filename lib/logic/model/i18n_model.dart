import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_music/generated/l10n.dart';
import 'package:flutter_music/ui/config/locale.dart';

class I18nModel with ChangeNotifier {
  late SupportedLocale _current;
  SupportedLocale get current => _current;

  Future<void> initialize() async {
    // print('${Platform.localeName}');
    // final locale = LocaleConfig.lookup(Platform.localeName);
    final locale = SupportedLocale.zh;
    await S.load(LocaleConfig.localeOf(locale));
    _current = locale;
  }

  void switchLocale(SupportedLocale target) async {
    await S.load(LocaleConfig.localeOf(target));
    _current = target;
    notifyListeners();
  }
}
