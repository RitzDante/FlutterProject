class PracticeTask {
  final String id;
  final String title;
  final String description;
  final String initialCode;
  final String expectedOutput;
  final String hint;
  final int difficulty; // 1-легкий, 2-средний, 3-сложный
  final bool isCompleted;

  PracticeTask({
    required this.id,
    required this.title,
    required this.description,
    required this.initialCode,
    required this.expectedOutput,
    required this.hint,
    this.difficulty = 1,
    this.isCompleted = false,
  });

  PracticeTask copyWith({
    String? id,
    String? title,
    String? description,
    String? initialCode,
    String? expectedOutput,
    String? hint,
    int? difficulty,
    bool? isCompleted,
  }) {
    return PracticeTask(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      initialCode: initialCode ?? this.initialCode,
      expectedOutput: expectedOutput ?? this.expectedOutput,
      hint: hint ?? this.hint,
      difficulty: difficulty ?? this.difficulty,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}