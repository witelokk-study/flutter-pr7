import 'package:flutter/material.dart';
import '../task.dart';

class HomeScreen extends StatefulWidget {
  final List<Task> tasks;
  final Function(Task) onTaskTap;

  HomeScreen({required this.tasks, required this.onTaskTap});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    List<Task> todayTasks = widget.tasks
        .where((task) =>
            task.date.day == today.day &&
            task.date.month == today.month &&
            task.date.year == today.year)
        .toList();

    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Text('Задачи на сегодня',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        SizedBox(height: 16),
        ...todayTasks.map((task) => ListTile(
              leading: Checkbox(
                  value: task.completed,
                  onChanged: (val) {
                    setState(() {
                      task.completed = val ?? false;
                    });
                  }),
              title: Text(task.title),
              subtitle: Text(task.description),
              onTap: () => widget.onTaskTap(task),
            )),
        if (todayTasks.isEmpty) Center(child: Text('Сегодня задач нет!')),
      ],
    );
  }
}