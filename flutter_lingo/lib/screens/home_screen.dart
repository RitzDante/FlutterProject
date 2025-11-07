import 'package:flutter/material.dart';

// Импорты наших кастомных классов
import '../config/lesson_data.dart';
import '../widgets/lesson_card.dart';
import 'lesson_screen.dart';

/*
HomeScreen - главный экран приложения
StatefulWidget потому что отслеживаем количество завершенных уроков
*/
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Переменная состояния - количество завершенных уроков
  int _completedLessons = 0;

  /*
  Метод initState вызывается один раз при создании виджета
  Идеально для начальной инициализации
  */
  @override
  void initState() {
    super.initState();
    _updateCompletedCount();
  }

  /*
  Метод для обновления счетчика завершенных уроков
  */
  void _updateCompletedCount() {
    final lessons = LessonData.getLessons();
    setState(() {
      _completedLessons = lessons.where((lesson) => lesson.isCompleted).length;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Получаем список уроков из нашего источника данных
    final lessons = LessonData.getLessons();

    return Scaffold(
      // AppBar - верхняя панель приложения
      appBar: AppBar(
        title: Text('Flutter Learning'),
        // Убираем кнопку настроек - переносим в профиль
      ),

      // Body - основное содержимое экрана
      body: Column(
        children: [
          // Верхняя панель с прогрессом
          _buildProgressSection(lessons.length),

          // Список уроков
          _buildLessonsList(lessons),
        ],
      ),
    );
  }

  /*
  Верхняя секция с прогрессом обучения
  */
  Widget _buildProgressSection(int totalLessons) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Текстовая информация о прогрессе
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ваш прогресс обучения',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  'Завершено $_completedLessons из $totalLessons уроков',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          // Круговой индикатор прогресса
          Stack(
            alignment: Alignment.center,
            children: [
              // Фон индикатора
              CircularProgressIndicator(
                value: _completedLessons / totalLessons,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                strokeWidth: 8,
              ),
              // Текст в центре
              Text(
                '${((_completedLessons / totalLessons) * 100).toInt()}%',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /*
  Список уроков с возможностью прокрутки
  */
  Widget _buildLessonsList(List<dynamic> lessons) {
    return Expanded(
      child: ListView.builder(
        itemCount: lessons.length,
        itemBuilder: (context, index) {
          final lesson = lessons[index];

          return LessonCard(
            lesson: lesson,
            onTap: () {
              // Навигация к экрану урока
              _navigateToLesson(context, lesson);
            },
          );
        },
      ),
    );
  }

  /*
  Метод для навигации к экрану урока
  */
  void _navigateToLesson(BuildContext context, lesson) async {
    /*
    Navigator.push переходит на новый экран
    MaterialPageRoute создает анимацию перехода как в нативных iOS/Android
    */
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LessonScreen(lesson: lesson)),
    );

    /*
    Когда возвращаемся с экрана урока, обновляем счетчик
    result может содержать информацию об изменениях
    */
    if (result == true) {
      _updateCompletedCount();
    }
  }
}
