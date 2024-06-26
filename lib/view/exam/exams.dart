import 'package:flutter/material.dart';
import 'package:future_green_world/view/exam/exam_model.dart';

class ExamsScreen extends StatelessWidget {
  final ExamModel examData;
  final int level;

  const ExamsScreen({required this.examData, required this.level, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${examData.name} - Level $level'),
      ),
      body: Center(
        child:
            Text('Welcome to the ${examData.name} Level $level exam screen!'),
      ),
    );
  }
}