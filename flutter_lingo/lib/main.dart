import 'package:flutter/material.dart';
import 'config/app_config.dart';
import 'screens/home_screen.dart';
import 'screens/practice_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.appName,
      theme: AppConfig.lightTheme,
      home: MainNavigationScreen(), // Теперь используем навигационный экран
      debugShowCheckedModeBanner: false,
    );
  }
}

/*
MainNavigationScreen - основной экран с нижней навигацией
StatefulWidget потому что отслеживаем текущую вкладку
*/
class MainNavigationScreen extends StatefulWidget {
  @override
  _MainNavigationScreenState createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  // Индекс текущей выбранной вкладки
  int _currentTabIndex = 0;

  // Список всех экранов для навигации
  final List<Widget> _screens = [
    HomeScreen(),
    PracticeScreen(),
    ProfileScreen(),
  ];

  // Метод для смены вкладки
  void _onTabTapped(int index) {
    setState(() {
      _currentTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Тело - текущий выбранный экран
      body: _screens[_currentTabIndex],
      
      // Нижняя навигационная панель
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTabIndex, // Текущая выбранная вкладка
        onTap: _onTabTapped, // Обработчик нажатия
        type: BottomNavigationBarType.fixed, // Фиксированный стиль (все иконки видны)
        backgroundColor: Colors.white, // Белый фон как в AppBar
        selectedItemColor: Colors.blue, // Цвет выбранной иконки
        unselectedItemColor: Colors.grey, // Цвет невыбранных иконок
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold), // Жирный шрифт для выбранной
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal), // Обычный шрифт для остальных
        
        // Элементы навигации
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.school), // Иконка для вкладки "Учиться"
            label: 'Учиться', // Подпись
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.code), // Иконка для вкладки "Практика"
            label: 'Практика',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person), // Иконка для вкладки "Профиль"
            label: 'Профиль',
          ),
        ],
      ),
    );
  }
}