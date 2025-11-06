// Импорты Flutter и Material Design для базовых компонентов
import 'package:flutter/material.dart';

// Импорты наших кастомных файлов
import 'config/app_config.dart';
import 'screens/home_screen.dart';

/*
Точка входа в приложение - функция main()
Эта функция запускает приложение при старте
*/
void main() {
  runApp(MyApp());
}

/*
Основной класс приложения, наследуется от StatelessWidget
StatelessWidget - виджет, который не меняет свое состояние
*/
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /*
    MaterialApp - корневой виджет Material Design приложения
    Здесь настраивается тема, заголовок и начальный экран
    */
    return MaterialApp(
      title: AppConfig.appName, // Название приложения из конфига
      theme: AppConfig.lightTheme, // Тема приложения
      home: HomeScreen(), // Первый экран, который видит пользователь
      debugShowCheckedModeBanner: false, // Убираем дебаг баннер
    );
  }
}
   