// Импорты Flutter
import 'package:flutter/material.dart';

// Импорт нашей модели
import '../models/lesson_model.dart';
import '../config/app_config.dart';

/*
LessonCard - переиспользуемый виджет для отображения урока в списке
StatelessWidget - потому что карточка сама не меняет свое состояние
*/
class LessonCard extends StatelessWidget {
  // Параметры, которые передаются в виджет
  final Lesson lesson; // Данные урока
  final VoidCallback onTap; // Функция, вызываемая при нажатии

  // Конструктор с обязательными параметрами
  const LessonCard({Key? key, required this.lesson, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    /*
    Card - Material Design карточка с тенью и скругленными углами
    Margin - внешние отступы
    */
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: AppConfig.mediumPadding,
        vertical: AppConfig.smallPadding,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConfig.cardRadius),
      ),
      child: InkWell(
        // InkWell добавляет анимацию при нажатии (ripple effect)
        onTap: onTap, // Вызываем переданную функцию
        borderRadius: BorderRadius.circular(AppConfig.cardRadius),
        child: Padding(
          padding: EdgeInsets.all(AppConfig.mediumPadding),
          child: Row(
            children: [
              // Левая часть: иконка категории
              _buildCategoryIcon(),

              SizedBox(width: AppConfig.mediumPadding), // Отступ
              // Центральная часть: текст
              Expanded(child: _buildLessonInfo()),

              // Правая часть: индикаторы
              _buildTrailingIndicators(),
            ],
          ),
        ),
      ),
    );
  }

  /*
  Вспомогательный метод для построения иконки категории
  Разбиваем на мелкие методы для читаемости
  */
  Widget _buildCategoryIcon() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: _getCategoryColor(), // Цвет в зависимости от категории
        shape: BoxShape.circle,
      ),
      child: Icon(
        _getCategoryIcon(), // Иконка в зависимости от категории
        color: Colors.white,
        size: 24,
      ),
    );
  }

  /*
  Вспомогательный метод для информации об уроке
  */
  Widget _buildLessonInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Заголовок урока
        Text(
          lesson.title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),

        SizedBox(height: 4), // Небольшой отступ
        // Описание урока
        Text(
          lesson.description,
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),

        SizedBox(height: 8),

        // Индикатор уровня сложности
        _buildLevelIndicator(),
      ],
    );
  }

  /*
  Вспомогательный метод для индикаторов справа
  */
  Widget _buildTrailingIndicators() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Иконка завершения урока
        if (lesson.isCompleted) Icon(Icons.check_circle, color: Colors.green),

        SizedBox(height: 4),

        // Иконка стрелки
        Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      ],
    );
  }

  /*
  Вспомогательный метод для индикатора уровня
  */
  Widget _buildLevelIndicator() {
    return Row(
      children: [
        // Текст уровня
        Text(
          'Уровень: ${lesson.level}',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),

        SizedBox(width: 8),

        // Визуальные точки для уровня сложности
        ...List.generate(3, (index) {
          return Container(
            margin: EdgeInsets.only(right: 2),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: index < lesson.level ? Colors.orange : Colors.grey[300],
              shape: BoxShape.circle,
            ),
          );
        }),
      ],
    );
  }

  /*
  Метод для определения цвета по категории
  Можно легко добавить новые категории
  */
  Color _getCategoryColor() {
    switch (lesson.category) {
      case 'Основы':
        return Colors.blue;
      case 'Виджеты':
        return Colors.green;
      case 'Навигация':
        return Colors.orange;
      case 'Анимации':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  /*
  Метод для определения иконки по категории
  */
  IconData _getCategoryIcon() {
    switch (lesson.category) {
      case 'Основы':
        return Icons.school;
      case 'Виджеты':
        return Icons.widgets;
      case 'Навигация':
        return Icons.navigation;
      case 'Анимации':
        return Icons.animation;
      default:
        return Icons.code;
    }
  }
}
