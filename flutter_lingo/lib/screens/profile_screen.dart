import 'package:flutter/material.dart';
import '../config/app_config.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _username;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final username = await AuthService.getUsername();
    setState(() {
      _username = username;
      _isLoading = false;
    });
  }

  void _logout() async {
    await AuthService.logout();
    Navigator.of(context).pushReplacementNamed('/auth');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Профиль'),
        backgroundColor: Colors.orange,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(AppConfig.mediumPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Карточка пользователя
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(AppConfig.mediumPadding),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.orange,
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          SizedBox(width: AppConfig.mediumPadding),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _username ?? 'Гость',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Ученик Flutter',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: AppConfig.largePadding),

                  // Раздел статистики
                  Text(
                    'Статистика обучения',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: AppConfig.mediumPadding),

                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(AppConfig.mediumPadding),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Icon(Icons.school, color: Colors.blue),
                            title: Text('Пройдено уроков'),
                            trailing: Text('3 из 10'),
                          ),
                          Divider(height: 1),
                          ListTile(
                            leading: Icon(Icons.timer, color: Colors.green),
                            title: Text('Время обучения'),
                            trailing: Text('4 ч 30 мин'),
                          ),
                          Divider(height: 1),
                          ListTile(
                            leading: Icon(Icons.star, color: Colors.amber),
                            title: Text('Уровень'),
                            trailing: Text('Начинающий'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: AppConfig.largePadding),

                  // Раздел настроек
                  Text(
                    'Настройки',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: AppConfig.mediumPadding),

                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.notifications, color: Colors.blue),
                          title: Text('Уведомления'),
                          trailing: Switch(value: true, onChanged: (value) {}),
                        ),
                        Divider(height: 1),
                        ListTile(
                          leading: Icon(Icons.nightlight_round, color: Colors.purple),
                          title: Text('Темная тема'),
                          trailing: Switch(value: false, onChanged: (value) {}),
                        ),
                        Divider(height: 1),
                        ListTile(
                          leading: Icon(Icons.language, color: Colors.green),
                          title: Text('Язык'),
                          trailing: Text('Русский'),
                        ),
                      ],
                    ),
                  ),

                  Spacer(), // Добавляет пространство между настройками и кнопкой выхода

                  // Кнопка выхода
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: _logout,
                      icon: Icon(Icons.logout),
                      label: Text('Выйти из аккаунта'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        minimumSize: Size(200, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}