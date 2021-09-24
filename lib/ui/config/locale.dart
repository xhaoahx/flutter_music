import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter_music/generated/l10n.dart';
import 'package:flutter_music/ui/helper/i18n.dart';

enum SupportedLocale {
  en,
  zh,
}

class LocaleConfig {
  static final _data = <SupportedLocale, Locale>{
    SupportedLocale.en: const Locale('en', ''),
    SupportedLocale.zh: const Locale('zh', ''),
  };

  static final _nameMap = <SupportedLocale, I18Getter>{};

  static SupportedLocale lookup(String languageCode) {
    return SupportedLocale.zh;
  }

  static Locale localeOf(SupportedLocale locale) {
    return _data[locale]!;
  }

  static String nameOf(SupportedLocale locale, BuildContext context) {
    return _nameMap[locale]!(S.of(context));
  }

  static late final values = _data.values;
}
