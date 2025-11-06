// Импортируем нашу модель урока
import '../models/lesson_model.dart';

/*
Класс LessonData содержит все данные уроков
В будущем можно заменить на загрузку из API или базы данных
*/
class LessonData {
  /*
  Статический метод, который возвращает список уроков
  static - означает, что метод можно вызвать без создания экземпляра класса
  */
  static List<Lesson> getLessons() {
    return [
      /*
      Урок 1: Основы Flutter
      Каждый урок создается через конструктор класса Lesson
      */
      Lesson(
        id: '1', // Уникальный ID
        title: 'Основы Flutter', // Заголовок
        description:
            'Познакомьтесь с архитектурой Flutter и создайте первое приложение', // Описание
        category: 'Основы', // Категория
        level: 1, // Уровень сложности (1-легкий)
        theory: '''
# Что такое Flutter?

Flutter - это фреймворк от Google для создания **кроссплатформенных** приложений.

## Основные концепции:

### Виджеты (Widgets)
- Все в Flutter является виджетом
- Виджеты - это строительные блоки UI
- Бывают Stateless и Stateful

### Stateless Widget
- Не изменяет свое состояние
- Пример: иконка, текст, кнопка

### Stateful Widget  
- Может изменять свое состояние
- Пример: счетчик, форма ввода

### Hot Reload
- Мгновенное обновление кода без перезапуска приложения
- Ускоряет разработку в разы!
        ''',
        codeExample: '''
// Импорт необходимых библиотек
import 'package:flutter/material.dart';

/*
Функция main() - точка входа в приложение
runApp() запускает приложение с корневым виджетом
*/
void main() {
  runApp(MyApp());
}

/*
MyApp - корневой виджет приложения
StatelessWidget - потому что не меняет состояние
*/
class MyApp extends StatelessWidget {
  /*
  Метод build описывает как виджет должен отображаться
  context - содержит информацию о расположении виджета в дереве
  */
  @override
  Widget build(BuildContext context) {
    // MaterialApp - основа Material Design
    return MaterialApp(
      home: Scaffold( // Scaffold - базовый макет экрана
        appBar: AppBar( // Верхняя панель
          title: Text('Мое первое приложение'),
        ),
        body: Center( // Центрирует содержимое
          child: Text('Привет, Flutter!'), // Текст
        ),
      ),
    );
  }
}
        ''',
      ),

      /*
      Урок 2: Stateless Widgets
      Добавляем новый урок - просто копируем структуру и меняем данные
      */
      Lesson(
        id: '2',
        title: 'Stateless Widgets',
        description: 'Научитесь создавать статические виджеты',
        category: 'Виджеты',
        level: 1,
        theory: '''
# Stateless Widget

StatelessWidget - это виджет, который **не изменяет** свое состояние.

## Когда использовать?
- Когда виджет зависит только от своих параметров (props)
- Когда данные не меняются со временем
- Для статических элементов: текст, иконки, картинки

## Особенности:
- Не имеет состояния (state)
- Перестраивается только когда меняются его параметры
- Более производительный чем StatefulWidget
        ''',
        codeExample: '''
import 'package:flutter/material.dart';

/*
Кастомный StatelessWidget
Принимает параметр text через конструктор
*/
class MyText extends StatelessWidget {
  // final - переменная не может быть изменена после инициализации
  final String text;
  
  // Конструктор с обязательным параметром text
  // Key? - необязательный параметр для идентификации виджета
  const MyText({Key? key, required this.text}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Text(
      text, // Используем переданный текст
      style: TextStyle(
        fontSize: 20,
        color: Colors.blue,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

// Использование нашего виджета
class ExampleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // Создаем экземпляр нашего виджета с параметром text
        child: MyText(text: 'Привет от кастомного виджета!'),
      ),
    );
  }
}
        ''',
      ),

      /*
      Урок 3: Stateful Widgets
      Показываем разницу между Stateless и Stateful
      */
      Lesson(
        id: '3',
        title: 'Stateful Widgets',
        description: 'Создавайте интерактивные виджеты с состоянием',
        category: 'Виджеты',
        level: 2,
        theory: '''
# Stateful Widget

StatefulWidget - это виджет, который **может изменять** свое состояние.

## Когда использовать?
- Когда данные меняются со временем
- Для интерактивных элементов: формы, анимации
- Когда виджет должен реагировать на действия пользователя

## Структура:
1. StatefulWidget - создает State
2. State - управляет состоянием и build методом

## setState()
- Уведомляет Flutter о изменении состояния
- Вызывает перестроение виджета
- Работает только внутри State класса
        ''',
        codeExample: '''
import 'package:flutter/material.dart';

/*
StatefulWidget состоит из двух классов:
1. Widget класс (создает State)
2. State класс (управляет состоянием)
*/

// 1. StatefulWidget класс
class Counter extends StatefulWidget {
  // Обязательный метод createState()
  @override
  _CounterState createState() => _CounterState();
}

// 2. State класс (содержит логику и отображение)
class _CounterState extends State<Counter> {
  // Переменная состояния - может изменяться
  int count = 0;
  
  // Метод для увеличения счетчика
  void increment() {
    // setState уведомляет Flutter о изменении состояния
    setState(() {
      count++; // Увеличиваем счетчик
    });
  }
  
  // Метод для сброса счетчика
  void reset() {
    setState(() {
      count = 0;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Отображаем текущее значение счетчика
        Text(
          'Счет: \$count', // \${} - интерполяция строк
          style: TextStyle(fontSize: 24),
        ),
        SizedBox(height: 20), // Отступ между элементами
        
        // Кнопка для увеличения счетчика
        ElevatedButton(
          onPressed: increment, // При нажатии вызываем increment
          child: Text('+1'),
        ),
        
        // Кнопка для сброса
        ElevatedButton(
          onPressed: reset,
          child: Text('Сброс'),
        ),
      ],
    );
  }
}
        ''',
      ),
    ];
  }

  /*
  Метод для получения уроков по категории
  Показывает как можно фильтровать данные
  */
  static List<Lesson> getLessonsByCategory(String category) {
    return getLessons().where((lesson) => lesson.category == category).toList();
  }

  /*
  Метод для получения урока по ID
  Полезно для навигации к конкретному уроку
  */
  static Lesson? getLessonById(String id) {
    try {
      return getLessons().firstWhere((lesson) => lesson.id == id);
    } catch (e) {
      return null; // Если урок не найден
    }
  }
}
