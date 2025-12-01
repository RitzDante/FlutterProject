import 'package:flutter/material.dart';
import '../config/app_config.dart';
import '../models/practice_task.dart';
import '../services/practice_service.dart';
import '../widgets/code_editor.dart';

class PracticeTaskScreen extends StatefulWidget {
  final PracticeTask task;

  const PracticeTaskScreen({Key? key, required this.task}) : super(key: key);

  @override
  _PracticeTaskScreenState createState() => _PracticeTaskScreenState();
}

class _PracticeTaskScreenState extends State<PracticeTaskScreen> {
  final TextEditingController _codeController = TextEditingController();
  final FocusNode _codeFocusNode = FocusNode();
  bool _isLoading = false;
  String _output = '';
  String _error = '';
  late PracticeTask _currentTask;

  @override
  void initState() {
    super.initState();
    _currentTask = widget.task;
    _loadUserCode();
  }

  void _loadUserCode() async {
    final savedCode = await PracticeService.getUserCode(_currentTask.id);
    setState(() {
      _codeController.text = savedCode.isNotEmpty ? savedCode : _currentTask.initialCode;
    });
  }

  void _saveCode() async {
    await PracticeService.saveUserCode(_currentTask.id, _codeController.text);
  }

  void _runCode() async {
    setState(() {
      _isLoading = true;
      _error = '';
      _output = '';
    });

    // Имитация обработки кода
    await Future.delayed(Duration(seconds: 1));

    final userCode = _codeController.text;

    // Простая проверка кода
    if (userCode.contains(_currentTask.expectedOutput)) {
      setState(() {
        _output = '✅ Код выполнен успешно!\n\nВы правильно использовали ${_currentTask.expectedOutput}';
      });
      
      // Отмечаем задание как выполненное
      await PracticeService.markTaskCompleted(_currentTask.id);
      _currentTask = _currentTask.copyWith(isCompleted: true);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Поздравляем! Задание выполнено! 🎉'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      setState(() {
        _error = '❌ В коде не найден ожидаемый элемент: ${_currentTask.expectedOutput}\n\n'
                'Проверьте, правильно ли вы используете требуемый виджет или метод.';
      });
    }

    setState(() {
      _isLoading = false;
    });
    
    // Сохраняем код
    _saveCode();
  }

  void _resetCode() {
    setState(() {
      _codeController.text = _currentTask.initialCode;
      _output = '';
      _error = '';
    });
    _saveCode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentTask.title),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(Icons.restart_alt),
            onPressed: _resetCode,
            tooltip: 'Сбросить код',
          ),
          if (_currentTask.isCompleted)
            Icon(Icons.check_circle, color: Colors.white),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(AppConfig.mediumPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Описание задания
            Card(
              child: Padding(
                padding: EdgeInsets.all(AppConfig.mediumPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _currentTask.description,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.star, size: 16, color: Colors.amber),
                        SizedBox(width: 4),
                        Text('Сложность: ${_currentTask.difficulty}/3'),
                        Spacer(),
                        if (_currentTask.isCompleted)
                          Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.green, size: 16),
                              SizedBox(width: 4),
                              Text('Выполнено', style: TextStyle(color: Colors.green)),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: AppConfig.mediumPadding),
            
            // Постоянная панель подсказок над редактором кода
            Card(
              margin: EdgeInsets.only(bottom: AppConfig.mediumPadding),
              child: ExpansionTile(
                leading: Icon(Icons.lightbulb_outline, color: Colors.amber),
                title: Text(
                  'Подсказки для выполнения задания',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.all(AppConfig.mediumPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Основная подсказка
                        Text(
                          _currentTask.hint,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 12),
                        
                        // Примеры кода для разных заданий
                        if (_currentTask.id == '1') 
                          _buildTextFieldHint(),
                        if (_currentTask.id == '2') 
                          _buildButtonHint(),
                        if (_currentTask.id == '3') 
                          _buildFormHint(),
                        if (_currentTask.id == '4') 
                          _buildNavigationHint(),
                        if (_currentTask.id == '5') 
                          _buildListViewHint(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Редактор кода
            Expanded(
              child: CodeEditor(
                controller: _codeController,
                focusNode: _codeFocusNode,
                hintText: 'Введите ваш код здесь...',
                onChanged: (value) => _saveCode(),
              ),
            ),
            
            SizedBox(height: AppConfig.mediumPadding),
            
            // Кнопка выполнения кода
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _runCode,
              icon: Icon(Icons.play_arrow),
              label: Text(_isLoading ? 'Выполнение...' : 'Выполнить код'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            
            SizedBox(height: AppConfig.mediumPadding),
            
            // Результат выполнения
            if (_output.isNotEmpty || _error.isNotEmpty)
              Expanded(
                flex: 1,
                child: Card(
                  color: _error.isNotEmpty ? Colors.red[50] : Colors.green[50],
                  child: Padding(
                    padding: EdgeInsets.all(AppConfig.mediumPadding),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _error.isNotEmpty ? 'Ошибка выполнения' : 'Результат',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _error.isNotEmpty ? Colors.red[800] : Colors.green[800],
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            _error.isNotEmpty ? _error : _output,
                            style: TextStyle(
                              color: _error.isNotEmpty ? Colors.red[700] : Colors.green[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFieldHint() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Пример использования TextField:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        SizedBox(height: 4),
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            'TextField(\n  decoration: InputDecoration(\n    labelText: "Введите текст",\n    border: OutlineInputBorder(),\n  ),\n)',
            style: TextStyle(
              fontFamily: 'Courier',
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButtonHint() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Пример использования ElevatedButton:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        SizedBox(height: 4),
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            'ElevatedButton(\n  onPressed: () {\n    print("Кнопка нажата!");\n  },\n  child: Text("Нажми меня"),\n)',
            style: TextStyle(
              fontFamily: 'Courier',
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormHint() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Пример формы с валидацией:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        SizedBox(height: 4),
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            'final _formKey = GlobalKey<FormState>();\n\nForm(\n  key: _formKey,\n  child: TextFormField(\n    validator: (value) {\n      if (value == null || value.isEmpty) {\n        return "Поле обязательно";\n      }\n      return null;\n    },\n  ),\n)',
            style: TextStyle(
              fontFamily: 'Courier',
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationHint() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Пример навигации между экранами:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        SizedBox(height: 4),
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            '// На главном экране\nElevatedButton(\n  onPressed: () {\n    Navigator.push(\n      context,\n      MaterialPageRoute(builder: (context) => SecondScreen()),\n    );\n  },\n  child: Text("Перейти"),\n)\n\n// Не забудьте создать класс SecondScreen',
            style: TextStyle(
              fontFamily: 'Courier',
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildListViewHint() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Пример создания списка:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        SizedBox(height: 4),
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            'ListView.builder(\n  itemCount: 10,\n  itemBuilder: (context, index) {\n    return ListTile(\n      title: Text("Элемент \$index"),\n      leading: Icon(Icons.circle),\n    );\n  },\n)',
            style: TextStyle(
              fontFamily: 'Courier',
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    _codeFocusNode.dispose();
    super.dispose();
  }
}