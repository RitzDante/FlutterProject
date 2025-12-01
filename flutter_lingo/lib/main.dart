import 'package:flutter/material.dart';
import 'config/app_config.dart';
import 'screens/main_navigator_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/reg_screen.dart';
import 'services/auth_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    bool isLoggedIn = await AuthService.isLoggedIn();
    setState(() {
      _isLoggedIn = isLoggedIn;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.appName,
      theme: AppConfig.lightTheme,
      
      // Маршруты приложения
      routes: {
        '/auth': (context) => AuthScreen(),  
        '/reg': (context) => RegScreen(),
        '/main': (context) => MainNavigationScreen(),
      },
      
      // Стартовый экран зависит от статуса авторизации
      home: _isLoading
          ? Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Загрузка...'),
                  ],
                ),
              ),
            )
          : _isLoggedIn ? MainNavigationScreen() : AuthScreen(), 
      
      debugShowCheckedModeBanner: false,
    );
  }
}