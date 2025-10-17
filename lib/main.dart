import 'package:flutter/material.dart';
import 'screen/home.dart';
import 'screen/tasks.dart';
import 'screen/calendar.dart';
import 'screen/task_detail.dart';
import 'screen/stats.dart';
import 'task.dart';

void main() {
  runApp(TaskPlannerApp());
}

class TaskPlannerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Planner',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  List<Task> tasks = [];

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(tasks: tasks, onTaskTap: _openTaskDetail),
      TasksScreen(tasks: tasks, onUpdate: _updateTasks, onTaskTap: _openTaskDetail),
      CalendarScreen(tasks: tasks, onTaskTap: _openTaskDetail),
      StatsScreen(tasks: tasks),
    ];
  }

  void _updateTasks() {
    setState(() {});
  }

  void _openTaskDetail(Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskDetailScreen(task: task, onUpdate: _updateTasks)),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Task Planner')),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Главная'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Задачи'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Календарь'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Статистика'),
        ],
      ),
    );
  }
}