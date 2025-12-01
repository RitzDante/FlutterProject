import 'package:flutter/material.dart';
import '../config/app_config.dart';
import '../data/practice_data.dart';
import '../models/practice_task.dart';
import '../services/practice_service.dart';
import 'practice_task_screen.dart';

class PracticeScreen extends StatefulWidget {
  @override
  _PracticeScreenState createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  List<PracticeTask> _tasks = [];
  Map<String, bool> _completionStatus = {};
  Map<String, dynamic> _progress = {'completed': 0, 'total': 0, 'percentage': 0};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final tasks = PracticeData.getPracticeTasks();
    final progress = await PracticeService.getProgress();
    
    // Проверяем статус выполнения для каждого задания
    Map<String, bool> status = {};
    for (var task in tasks) {
      final isCompleted = await PracticeService.isTaskCompleted(task.id);
      status[task.id] = isCompleted;
    }

    setState(() {
      _tasks = tasks;
      _completionStatus = status;
      _progress = progress;
    });
  }

  void _navigateToTask(PracticeTask task) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PracticeTaskScreen(task: task),
      ),
    );

    // Обновляем данные если задание было завершено
    if (result == true) {
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Практика'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          // Панель прогресса
          _buildProgressSection(),
          
          // Список заданий
          _buildTasksList(),
        ],
      ),
    );
  }

 Widget _buildProgressSection() {
  final completed = _progress['completed'] ?? 0;
  final total = _progress['total'] ?? _tasks.length;
  final percentage = total > 0 ? ((completed / total) * 100).round() : 0;
  
  return Container(
    margin: EdgeInsets.all(AppConfig.mediumPadding),
    padding: EdgeInsets.all(AppConfig.mediumPadding),
    decoration: BoxDecoration(
      color: Colors.green[50],
      borderRadius: BorderRadius.circular(AppConfig.cardRadius),
      boxShadow: [
        BoxShadow(
          color: Colors.green[100]!,
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.assessment, color: Colors.green[800]),
            SizedBox(width: 8),
            Text(
              'Прогресс практики',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Выполнено заданий',
                    style: TextStyle(
                      color: Colors.green[600],
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '$completed из $total',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                  ),
                ],
              ),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 70,
                  height: 70,
                  child: CircularProgressIndicator(
                    value: percentage / 100,
                    backgroundColor: Colors.green[100],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                    strokeWidth: 8,
                  ),
                ),
                Text(
                  '$percentage%',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 8),
        // Добавим индикатор следующего уровня
        if (completed < total)
          Text(
            'Следующее задание: ${_getNextTaskTitle()}',
            style: TextStyle(
              color: Colors.green[600],
              fontSize: 12,
            ),
          ),
      ],
    ),
  );
}

// Добавим вспомогательный метод для получения названия следующего задания
String _getNextTaskTitle() {
  for (var task in _tasks) {
    if (!(_completionStatus[task.id] ?? false)) {
      return task.title;
    }
  }
  return 'Все задания выполнены!';
}

  Widget _buildTasksList() {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: AppConfig.mediumPadding,
          vertical: AppConfig.smallPadding,
        ),
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          final isCompleted = _completionStatus[task.id] ?? false;

          return Card(
            margin: EdgeInsets.only(bottom: AppConfig.smallPadding),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConfig.cardRadius),
            ),
            child: InkWell(
              onTap: () => _navigateToTask(task),
              borderRadius: BorderRadius.circular(AppConfig.cardRadius),
              child: Padding(
                padding: EdgeInsets.all(AppConfig.mediumPadding),
                child: Row(
                  children: [
                    // Иконка задания
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: _getDifficultyColor(task.difficulty),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.code,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    SizedBox(width: AppConfig.mediumPadding),
                    
                    // Информация о задании
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            task.description,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              // Индикатор сложности
                              ...List.generate(3, (index) {
                                return Container(
                                  margin: EdgeInsets.only(right: 2),
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: index < task.difficulty 
                                        ? _getDifficultyColor(task.difficulty) 
                                        : Colors.grey[300],
                                    shape: BoxShape.circle,
                                  ),
                                );
                              }),
                              SizedBox(width: 8),
                              Text(
                                'Сложность: ${task.difficulty}/3',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    // Индикаторы справа
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isCompleted)
                          Icon(Icons.check_circle, color: Colors.green),
                        SizedBox(height: 4),
                        Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getDifficultyColor(int difficulty) {
    switch (difficulty) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}