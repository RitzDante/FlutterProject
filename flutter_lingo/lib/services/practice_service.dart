import 'package:shared_preferences/shared_preferences.dart';
import '../models/practice_task.dart';
import '../data/practice_data.dart'; // Добавляем импорт

class PracticeService {
  static const String _completedTasksKey = 'completed_practice_tasks';
  static const String _userCodeKeyPrefix = 'user_code_';

  // Сохранение кода пользователя для конкретного задания
  static Future<void> saveUserCode(String taskId, String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('$_userCodeKeyPrefix$taskId', code);
  }

  // Получение кода пользователя для конкретного задания
  static Future<String> getUserCode(String taskId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('$_userCodeKeyPrefix$taskId') ?? '';
  }

  // Отметка задания как завершенного
  static Future<void> markTaskCompleted(String taskId) async {
    final prefs = await SharedPreferences.getInstance();
    final completedTasks = prefs.getStringList(_completedTasksKey) ?? [];
    if (!completedTasks.contains(taskId)) {
      completedTasks.add(taskId);
      await prefs.setStringList(_completedTasksKey, completedTasks);
    }
  }

  // Проверка, завершено ли задание
  static Future<bool> isTaskCompleted(String taskId) async {
    final prefs = await SharedPreferences.getInstance();
    final completedTasks = prefs.getStringList(_completedTasksKey) ?? [];
    return completedTasks.contains(taskId);
  }

  // Получение прогресса
  static Future<Map<String, dynamic>> getProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final completedTasks = prefs.getStringList(_completedTasksKey) ?? [];
    final allTasks = PracticeData.getPracticeTasks(); // Используем PracticeData
    
    return {
      'completed': completedTasks.length,
      'total': allTasks.length,
      'percentage': allTasks.isEmpty ? 0 : (completedTasks.length / allTasks.length * 100).toInt(),
    };
  }

  // Получение всех заданий (теперь не используется, но оставим)
  static List<PracticeTask> _getAllTasks() {
    return PracticeData.getPracticeTasks();
  }
}