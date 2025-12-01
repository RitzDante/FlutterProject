import '../models/practice_task.dart';

class PracticeData {
  static List<PracticeTask> getPracticeTasks() {
    return [
      PracticeTask(
        id: '1',
        title: 'Создание полей ввода',
        description: 'Научитесь создавать текстовые поля ввода в Flutter',
        initialCode: '''import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Практика: Поле ввода')),
        body: Center(
          // TODO: Добавьте TextField здесь
          child: Text('Замените этот текст на TextField'),
        ),
      ),
    );
  }
}''',
        expectedOutput: 'TextField',
        hint: 'Используйте виджет TextField с decoration для красивого оформления',
        difficulty: 1,
      ),
      PracticeTask(
        id: '2',
        title: 'Кнопка с обработчиком',
        description: 'Создайте кнопку, которая реагирует на нажатие',
        initialCode: '''import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Практика: Кнопка')),
        body: Center(
          // TODO: Добавьте ElevatedButton здесь
          child: Text('Добавьте кнопку с обработчиком onPressed'),
        ),
      ),
    );
  }
}''',
        expectedOutput: 'ElevatedButton',
        hint: 'Используйте ElevatedButton и определите onPressed обработчик',
        difficulty: 1,
      ),
      PracticeTask(
        id: '3',
        title: 'Форма с валидацией',
        description: 'Создайте форму с проверкой введенных данных',
        initialCode: '''import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Практика: Форма')),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          // TODO: Создайте форму с валидацией
          child: Column(
            children: [
              Text('Создайте форму с полями и кнопкой отправки'),
            ],
          ),
        ),
      ),
    );
  }
}''',
        expectedOutput: 'TextFormField',
        hint: 'Используйте TextFormField с validator и Form с GlobalKey',
        difficulty: 2,
      ),
    ];
  }

  static PracticeTask? getTaskById(String id) {
    try {
      return getPracticeTasks().firstWhere((task) => task.id == id);
    } catch (e) {
      return null;
    }
  }
}