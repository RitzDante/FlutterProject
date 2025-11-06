import 'package:flutter/material.dart';

// Импорты наших кастомных классов
import '../models/lesson_model.dart';
import '../widgets/code_display.dart';
import '../config/app_config.dart';

/*
LessonScreen - экран для отображения конкретного урока
StatefulWidget потому что есть состояние (выбранная вкладка)
*/
class LessonScreen extends StatefulWidget {
  final Lesson lesson; // Урок, который отображаем

  const LessonScreen({Key? key, required this.lesson}) : super(key: key);

  @override
  _LessonScreenState createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  // Состояние - какая вкладка выбрана (0=теория, 1=код)
  int _selectedTabIndex = 0;

  // Локальная копия урока (может меняться при завершении)
  late Lesson _currentLesson;

  /*
  Инициализация состояния при создании виджета
  */
  @override
  void initState() {
    super.initState();
    _currentLesson = widget.lesson; // Копируем переданный урок
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // Панель вкладок
          _buildTabBar(),

          // Содержимое в зависимости от выбранной вкладки
          Expanded(child: _buildCurrentTabContent()),
        ],
      ),
    );
  }

  /*
  Верхняя панель с заголовком и действиями
  */
  AppBar _buildAppBar() {
    return AppBar(
      title: Text(_currentLesson.title),
      actions: [
        // Кнопка завершения/открытия урока
        IconButton(
          icon: Icon(
            _currentLesson.isCompleted
                ? Icons.check_circle
                : Icons.check_circle_outline,
            color: _currentLesson.isCompleted ? Colors.green : Colors.grey,
          ),
          onPressed: _toggleLessonCompletion,
          tooltip: _currentLesson.isCompleted
              ? 'Отметить как не завершенный'
              : 'Завершить урок',
        ),

        // Кнопка поделиться (можно добавить позже)
        IconButton(
          icon: Icon(Icons.share),
          onPressed: () {
            // TODO: Добавить функционал поделиться
          },
        ),
      ],
    );
  }

  /*
  Панель с вкладками для переключения между теорией и кодом
  */
  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          // Вкладка "Теория"
          _buildTab(0, 'Теория', Icons.menu_book),

          // Вкладка "Код"
          _buildTab(1, 'Код', Icons.code),
        ],
      ),
    );
  }

  /*
  Построение одной вкладки
  */
  Widget _buildTab(int index, String title, IconData icon) {
    final isSelected = _selectedTabIndex == index;

    return Expanded(
      child: Material(
        color: isSelected ? Colors.blue[50] : Colors.transparent,
        child: InkWell(
          onTap: () => setState(() => _selectedTabIndex = index),
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: isSelected ? Colors.blue : Colors.grey),
                SizedBox(height: 4),
                Text(
                  title,
                  style: TextStyle(
                    color: isSelected ? Colors.blue : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /*
  Содержимое активной вкладки
  */
  Widget _buildCurrentTabContent() {
    switch (_selectedTabIndex) {
      case 0: // Теория
        return _buildTheoryTab();
      case 1: // Код
        return _buildCodeTab();
      default:
        return _buildTheoryTab();
    }
  }

  /*
  Вкладка с теоретическим материалом
  */
  Widget _buildTheoryTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppConfig.mediumPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок урока
          Text(
            _currentLesson.title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          SizedBox(height: 8),

          // Описание урока
          Text(
            _currentLesson.description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),

          SizedBox(height: 16),

          // Разделитель
          Divider(),

          SizedBox(height: 16),

          // Теоретический материал
          Text(
            _currentLesson.theory,
            style: TextStyle(
              fontSize: 16,
              height: 1.6, // Межстрочный интервал для лучшей читаемости
            ),
          ),

          // Подсказка для начинающих (только для уровня 1)
          if (_currentLesson.level == 1) _buildBeginnerTip(),
        ],
      ),
    );
  }

  /*
  Подсказка для начинающих
  */
  Widget _buildBeginnerTip() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber),
      ),
      child: Row(
        children: [
          Icon(Icons.lightbulb_outline, color: Colors.amber),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Это базовый урок. Рекомендуем начать изучение Flutter именно отсюда!',
              style: TextStyle(color: Colors.amber[800]),
            ),
          ),
        ],
      ),
    );
  }

  /*
  Вкладка с примером кода
  */
  Widget _buildCodeTab() {
    return CodeDisplay(
      code: _currentLesson.codeExample,
      fileName: 'main.dart', // Можно сделать умнее - определять по содержанию
    );
  }

  /*
  Переключение статуса завершения урока
  */
  void _toggleLessonCompletion() {
    setState(() {
      _currentLesson = _currentLesson.copyWith(
        isCompleted: !_currentLesson.isCompleted,
      );
    });

    // Показываем уведомление пользователю
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _currentLesson.isCompleted
              ? 'Урок "${_currentLesson.title}" завершен! 🎉'
              : 'Урок "${_currentLesson.title}" снова открыт для изучения',
        ),
        duration: Duration(seconds: 2),
      ),
    );

    // Возвращаем результат обратно на главный экран
    // В реальном приложении здесь можно сохранить в базу данных
    Navigator.pop(context, true);
  }
}
