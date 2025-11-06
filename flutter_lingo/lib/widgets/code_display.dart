import 'package:flutter/material.dart';
import '../config/app_config.dart';

/*
CodeDisplay - виджет для красивого отображения кода
Переиспользуемый across разных экранов
*/
class CodeDisplay extends StatelessWidget {
  final String code; // Код для отображения
  final String fileName; // Имя файла (опционально)

  const CodeDisplay({
    Key? key,
    required this.code,
    this.fileName = 'main.dart', // Значение по умолчанию
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900], // Темный фон для кода
        borderRadius: BorderRadius.circular(AppConfig.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок с именем файла
          _buildHeader(context),

          // Область с кодом
          _buildCodeArea(),
        ],
      ),
    );
  }

  /*
  Верхняя панель с именем файла и кнопками
  */
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppConfig.smallPadding),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppConfig.cardRadius),
          topRight: Radius.circular(AppConfig.cardRadius),
        ),
      ),
      child: Row(
        children: [
          // Имя файла
          Text(
            fileName,
            style: TextStyle(
              color: Colors.white54,
              fontSize: 14,
              fontFamily: 'Courier',
            ),
          ),

          Spacer(), // Занимает все доступное пространство
          // Кнопка копирования
          IconButton(
            icon: Icon(Icons.copy, size: 18, color: Colors.white54),
            onPressed: () => _copyToClipboard(context),
            tooltip: 'Копировать код',
          ),
        ],
      ),
    );
  }

  /*
  Область с прокручиваемым кодом
  */
  Widget _buildCodeArea() {
    return Expanded(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(AppConfig.mediumPadding),
        child: SelectableText(
          code, // Код для отображения
          style: TextStyle(
            fontFamily: 'Courier', // Моноширинный шрифт для кода
            color: Colors.white,
            fontSize: 14,
            height: 1.5, // Межстрочный интервал
          ),
        ),
      ),
    );
  }

  /*
  Метод для копирования кода в буфер обмена
  */
  void _copyToClipboard(BuildContext context) {
    // В реальном приложении здесь будет вызов Clipboard.setData
    // Показываем уведомление пользователю
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Код скопирован в буфер обмена!'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
