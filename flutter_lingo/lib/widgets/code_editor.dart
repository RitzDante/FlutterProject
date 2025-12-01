import 'package:flutter/material.dart';
import '../config/app_config.dart';

class CodeEditor extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String hintText;
  final ValueChanged<String>? onChanged;

  const CodeEditor({
    Key? key,
    required this.controller,
    this.focusNode,
    this.hintText = 'Введите код...',
    this.onChanged,
  }) : super(key: key);

  @override
  _CodeEditorState createState() => _CodeEditorState();
}

class _CodeEditorState extends State<CodeEditor> {
  // Простая подсветка ключевых слов Dart
  static const List<String> _keywords = [
    'import', 'void', 'main', 'class', 'extends', 'override',
    'Widget', 'build', 'context', 'return', 'final', 'const',
    'var', 'if', 'else', 'for', 'while', 'try', 'catch',
    'true', 'false', 'null', 'static', 'async', 'await',
    'Future', 'setState', 'Scaffold', 'AppBar', 'Text',
    'MaterialApp', 'Center', 'Column', 'Row', 'Container',
    'Padding', 'EdgeInsets', 'SizedBox', 'Icon', 'Icons',
  ];

  static const List<String> _dartTypes = [
    'String', 'int', 'double', 'bool', 'List', 'Map',
    'BuildContext', 'Key', 'Widget',
  ];

  TextSpan _buildTextSpan(String text) {
    List<TextSpan> spans = [];
    List<String> lines = text.split('\n');

    for (int i = 0; i < lines.length; i++) {
      String line = lines[i];
      
      // Добавляем номер строки
      spans.add(
        TextSpan(
          text: '${(i + 1).toString().padLeft(3)} ',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
            fontFamily: 'Courier',
          ),
        ),
      );

      // Разделяем строку на слова и символы
      String currentWord = '';
      for (int j = 0; j < line.length; j++) {
        String char = line[j];
        
        if (RegExp(r'[\w]').hasMatch(char)) {
          currentWord += char;
        } else {
          // Обрабатываем накопленное слово
          if (currentWord.isNotEmpty) {
            bool isKeyword = _keywords.contains(currentWord);
            bool isType = _dartTypes.contains(currentWord);
            
            Color color;
            if (isKeyword) {
              color = Colors.blue;
            } else if (isType) {
              color = Colors.purple;
            } else if (RegExp(r'^[A-Z]').hasMatch(currentWord)) {
              color = Colors.green;
            } else if (currentWord.startsWith('_')) {
              color = Colors.brown;
            } else {
              color = Colors.black87;
            }
            
            spans.add(
              TextSpan(
                text: currentWord,
                style: TextStyle(
                  fontFamily: 'Courier',
                  fontSize: 14,
                  color: color,
                  fontWeight: isKeyword || isType ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            );
            currentWord = '';
          }
          
          // Добавляем символ
          spans.add(
            TextSpan(
              text: char,
              style: TextStyle(
                fontFamily: 'Courier',
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          );
        }
      }
      
      // Обрабатываем последнее слово в строке
      if (currentWord.isNotEmpty) {
        bool isKeyword = _keywords.contains(currentWord);
        bool isType = _dartTypes.contains(currentWord);
        
        Color color;
        if (isKeyword) {
          color = Colors.blue;
        } else if (isType) {
          color = Colors.purple;
        } else if (RegExp(r'^[A-Z]').hasMatch(currentWord)) {
          color = Colors.green;
        } else if (currentWord.startsWith('_')) {
          color = Colors.brown;
        } else {
          color = Colors.black87;
        }
        
        spans.add(
          TextSpan(
            text: currentWord,
            style: TextStyle(
              fontFamily: 'Courier',
              fontSize: 14,
              color: color,
              fontWeight: isKeyword || isType ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        );
      }

      // Добавляем перевод строки (кроме последней)
      if (i < lines.length - 1) {
        spans.add(TextSpan(text: '\n'));
      }
    }

    return TextSpan(children: spans);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(AppConfig.cardRadius),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Заголовок редактора
          Container(
            padding: EdgeInsets.all(AppConfig.smallPadding),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppConfig.cardRadius),
                topRight: Radius.circular(AppConfig.cardRadius),
              ),
              border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
            ),
            child: Row(
              children: [
                Icon(Icons.code, size: 16, color: Colors.grey[700]),
                SizedBox(width: 8),
                Text(
                  'Редактор кода',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Dart',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Область редактора
          Expanded(
            child: Stack(
              children: [
                // Подложка с подсветкой синтаксиса
                Padding(
                  padding: EdgeInsets.only(
                    top: AppConfig.smallPadding,
                    left: AppConfig.smallPadding,
                    right: AppConfig.smallPadding,
                    bottom: AppConfig.smallPadding,
                  ),
                  child: SingleChildScrollView(
                    child: SelectableText.rich(
                      _buildTextSpan(widget.controller.text),
                      style: TextStyle(
                        fontFamily: 'Courier',
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
                
                // Прозрачное поле ввода поверх
                Padding(
                  padding: EdgeInsets.only(
                    top: AppConfig.smallPadding,
                    left: AppConfig.smallPadding,
                    right: AppConfig.smallPadding,
                    bottom: AppConfig.smallPadding,
                  ),
                  child: TextField(
                    controller: widget.controller,
                    focusNode: widget.focusNode,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    style: TextStyle(
                      fontFamily: 'Courier',
                      fontSize: 14,
                      color: Colors.transparent,
                      height: 1.5,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: widget.hintText,
                      hintStyle: TextStyle(
                        fontFamily: 'Courier',
                        fontSize: 14,
                        color: Colors.grey[400],
                        height: 1.5,
                      ),
                    ),
                    onChanged: widget.onChanged,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}