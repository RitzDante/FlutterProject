import 'package:flutter/material.dart';

/*
Класс AppConfig содержит все константы и настройки приложения
Это удобно - все настройки в одном месте, легко менять
*/
class AppConfig {
  // Название приложения
  static const String appName = 'Flutter Learning';

  // Версия приложения
  static const String appVersion = '1.0.0';

  // Светлая тема приложения
  static final ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.blue, // Основной цвет
    scaffoldBackgroundColor: Colors.white, // Цвет фона
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.blue, // Цвет AppBar
      foregroundColor: Colors.white, // Цвет текста в AppBar
      elevation: 0, // Тень под AppBar (0 - без тени)
    ),
    fontFamily: 'SF Pro', // Шрифт (если доступен на iOS)
  );

  // Темная тема (можно добавить позже)
  static final ThemeData darkTheme = ThemeData(
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.grey[900],
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[900],
      foregroundColor: Colors.white,
      elevation: 0,
    ),
  );

  // Размеры отступов для единообразия
  static const double smallPadding = 8.0;
  static const double mediumPadding = 16.0;
  static const double largePadding = 24.0;

  // Радиусы скругления
  static const double cardRadius = 12.0;
  static const double buttonRadius = 8.0;
}
