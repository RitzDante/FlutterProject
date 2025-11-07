import 'package:flutter/material.dart';
import '../config/app_config.dart';

class PracticeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Практика'),
        backgroundColor: Colors.green, // Другой цвет для отличия
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.code,
              size: 64,
              color: Colors.green,
            ),
            SizedBox(height: AppConfig.mediumPadding),
            Text(
              'Раздел практики',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: AppConfig.smallPadding),
            Text(
              'Здесь будут практические задания',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}