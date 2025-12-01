import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Авторизация'),
        backgroundColor: Colors.indigo,
      ),
      body: _AuthBody(),
    );
  }
}

class _AuthBody extends StatefulWidget {
  @override
  State<_AuthBody> createState() => _AuthBodyState();
}

class _AuthBodyState extends State<_AuthBody> {
  Map<String, String> users = {
    'Sergey': '123',
    'Kate': '123',
    'Natasha': '123',
  };
  
  bool okey = false;
  bool found = false;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void checkname(String txt) {
    print(txt);
    setState(() {
      found = users.containsKey(txt);
      // Сбрасываем состояние пароля при изменении имени
      if (!found) {
        okey = false;
      }
    });
  }

  void checkPass(String pass) {
    setState(() {
      if (found && usernameController.text.isNotEmpty) {
        okey = users[usernameController.text] == pass;
      }
    });
  }

  void _login() async {
    if (okey) {
      // Используем AuthService для входа
      bool success = await AuthService.login(
        usernameController.text.trim(),
        passwordController.text.trim(),
      );
      
      if (success) {
        Navigator.of(context).pushReplacementNamed('/main');
      } else {
        // Показываем ошибку
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка входа'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            controller: usernameController,
            decoration: const InputDecoration(
              hintText: 'Please write a username',
              border: OutlineInputBorder(),
            ),
            onChanged: (txt) {
              checkname(txt);
            },
          ),
          SizedBox(height: 20),
          Text(found == true ? 'Найден' : 'Не найден'),
          SizedBox(height: 20),
          TextFormField(
            controller: passwordController,
            readOnly: !found,
            obscureText: true,
            decoration: const InputDecoration(
              hintText: 'Please write a password',
              border: OutlineInputBorder(),
            ),
            onChanged: (pass) {
              checkPass(pass);
            },
          ),
          SizedBox(height: 20),
          if (okey)
            ElevatedButton(
              onPressed: _login,
              child: Text("Вход"),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/reg');
              },
              child: Text('Нет аккаунта? Зарегистрироваться'),
            ),
        ],
      ),
    );
    
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}