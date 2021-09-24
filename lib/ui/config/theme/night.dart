import 'package:flutter/material.dart';

const _fontColor = Color(0xFF9E9FA4);

final nightTheme = ThemeData.from(
  colorScheme: ColorScheme(
    primary: const Color(0xFF292A2C),
    primaryVariant: const Color(0xFF202125),
    secondary: Color(0xFF0886FF),
    secondaryVariant: Color(0xFF113453),
// primaryVariant
    surface: Color(0xFF202125),
// primary
    background: Color(0xFF292A2C),
    error: Colors.red.shade500,
    onPrimary: Color(0xFF9E9FA4),
    onSecondary: Color(0xFF9E9FA4),
    onSurface: _fontColor,
    onBackground: _fontColor,
    onError: Colors.yellow,
    brightness: Brightness.dark,
  ),
  textTheme: Typography.material2018().black.apply(),
);
