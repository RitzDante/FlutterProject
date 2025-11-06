/*
Модель данных Lesson представляет собой урок в приложении
Модели нужны для структурирования данных и типобезопасности
*/
class Lesson {
  // Уникальный идентификатор урока
  final String id;

  // Заголовок урока (отображается в списке)
  final String title;

  // Описание урока (краткое пояснение)
  final String description;

  // Категория урока (для группировки и цветового кодирования)
  final String category;

  // Уровень сложности (1-легкий, 2-средний, 3-сложный)
  final int level;

  // Пример кода для этого урока
  final String codeExample;

  // Теоретическая часть урока
  final String theory;

  // Статус выполнения урока
  final bool isCompleted;

  // Конструктор класса Lesson
  // required - означает, что параметр обязательный
  Lesson({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.level,
    required this.codeExample,
    required this.theory,
    this.isCompleted = false, // По умолчанию урок не завершен
  });

  /*
  Метод copyWith создает копию объекта с измененными полями
  Это полезно для immutable (неизменяемых) объектов в Flutter
  */
  Lesson copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    int? level,
    String? codeExample,
    String? theory,
    bool? isCompleted,
  }) {
    return Lesson(
      id: id ?? this.id, // Если новый id не передан, используем старый
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      level: level ?? this.level,
      codeExample: codeExample ?? this.codeExample,
      theory: theory ?? this.theory,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  /*
  Преобразование объекта в Map (полезно для сохранения в базу данных)
  */
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'level': level,
      'codeExample': codeExample,
      'theory': theory,
      'isCompleted': isCompleted,
    };
  }

  /*
  Создание объекта Lesson из Map (полезно для загрузки из базы данных)
  factory - специальный конструктор, который может возвращать экземпляры
  */
  factory Lesson.fromMap(Map<String, dynamic> map) {
    return Lesson(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      category: map['category'],
      level: map['level'],
      codeExample: map['codeExample'],
      theory: map['theory'],
      isCompleted: map['isCompleted'] ?? false,
    );
  }
}
