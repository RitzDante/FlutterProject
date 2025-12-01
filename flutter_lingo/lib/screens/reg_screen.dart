import 'package:flutter/material.dart';
import '../config/app_config.dart';
import '../services/auth_service.dart';

class RegScreen extends StatefulWidget {
  const RegScreen({super.key});

  @override
  State<RegScreen> createState() => _RegScreenState();
}

class _RegScreenState extends State<RegScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  void _register() async {
    if (nameController.text.isEmpty || 
        passController.text.isEmpty || 
        confirmPassController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Заполните все поля'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (passController.text != confirmPassController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Пароли не совпадают'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (passController.text.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Пароль должен быть не менее 3 символов'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Имитация регистрации
    await Future.delayed(Duration(seconds: 2));

    // В реальном приложении здесь была бы регистрация на сервере
    // Сейчас просто автоматически логиним пользователя
    bool loginSuccess = await AuthService.login(
      nameController.text.trim(), 
      passController.text.trim()
    );

    setState(() {
      _isLoading = false;
    });

    if (loginSuccess) {
      // Переходим на главный экран
      Navigator.of(context).pushReplacementNamed('/main');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка регистрации'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Регистрация'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: EdgeInsets.all(AppConfig.mediumPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Создайте аккаунт',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: AppConfig.largePadding),

            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Имя пользователя',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Введите имя пользователя';
                }
                return null;
              },
            ),
            SizedBox(height: AppConfig.mediumPadding),

            TextFormField(
              controller: passController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: 'Пароль',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Введите пароль';
                }
                if (value.length < 3) {
                  return 'Пароль должен быть не менее 3 символов';
                }
                return null;
              },
            ),
            SizedBox(height: AppConfig.mediumPadding),

            TextFormField(
              controller: confirmPassController,
              obscureText: _obscureConfirmPassword,
              decoration: InputDecoration(
                labelText: 'Подтвердите пароль',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Подтвердите пароль';
                }
                if (value != passController.text) {
                  return 'Пароли не совпадают';
                }
                return null;
              },
            ),
            SizedBox(height: AppConfig.largePadding),

            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _register,
                    child: Text('Зарегистрироваться'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      backgroundColor: Colors.purple,
                    ),
                  ),

            SizedBox(height: AppConfig.mediumPadding),

            // Кнопка перехода к авторизации
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: Text('Уже есть аккаунт? Войти'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    passController.dispose();
    confirmPassController.dispose();
    super.dispose();
  }
}