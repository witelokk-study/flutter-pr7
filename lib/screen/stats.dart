import 'package:flutter/material.dart';
import '../task.dart';

class StatsScreen extends StatelessWidget {
  final List<Task> tasks;
  StatsScreen({required this.tasks});

  @override
  Widget build(BuildContext context) {
    int total = tasks.length;
    int completed = tasks.where((t) => t.completed).length;
    int pending = total - completed;

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text('Статистика задач', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          LinearProgressIndicator(value: total == 0 ? 0 : completed / total),
          SizedBox(height: 16),
          Text('Всего задач: $total'),
          Text('Выполнено: $completed'),
          Text('Осталось: $pending'),
        ],
      ),
    );
  }
}
