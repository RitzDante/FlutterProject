import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _usernameKey = 'username';

  // Тестовые учетные данные (такие же как в AuthScreen)
  static final Map<String, String> _testUsers = {
    'Sergey': '123',
    'Kate': '123',
    'Natasha': '123',
    'test': '123',
  };

  // Проверка логина и пароля
  static bool validateCredentials(String username, String password) {
    return _testUsers.containsKey(username) && _testUsers[username] == password;
  }

  // Проверка, авторизован ли пользователь
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // Получение имени пользователя
  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }

  // Вход в систему
  static Future<bool> login(String username, String password) async {
    if (validateCredentials(username, password)) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isLoggedInKey, true);
      await prefs.setString(_usernameKey, username);
      return true;
    }
    return false;
  }

  // Выход из системы (ДОБАВИТЬ ЕСЛИ ЕЩЕ НЕТ)
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, false);
    await prefs.remove(_usernameKey);
    print('Пользователь вышел из системы');
  }
}