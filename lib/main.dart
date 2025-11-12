import 'package:flutter/material.dart';
import 'screen/home.dart';
import 'screen/tasks.dart';
import 'screen/calendar.dart';
import 'screen/task_detail.dart';
import 'screen/stats.dart';
import 'task.dart';

void main() {
  final appState = AppState();
  runApp(TaskPlannerApp(appState: appState));
}

class AppState extends ChangeNotifier {
  final List<Task> tasks = [];

  void notify() => notifyListeners();
}

class TaskPlannerApp extends StatelessWidget {
  final AppState appState;
  TaskPlannerApp({required this.appState});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Planner',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TabPage(index: 0, appState: appState),
    );
  }
}

class TabPage extends StatefulWidget {
  final int index;
  final AppState appState;
  TabPage({required this.index, required this.appState});

  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.index;
    widget.appState.addListener(_onAppState);
  }

  @override
  void dispose() {
    widget.appState.removeListener(_onAppState);
    super.dispose();
  }

  void _onAppState() => setState(() {});

  void _openTaskDetail(Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskDetailScreen(task: task, onUpdate: () => widget.appState.notify())),
    );
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    
    final newPage = TabPage(index: index, appState: widget.appState);
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => newPage,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(tasks: widget.appState.tasks, onTaskTap: _openTaskDetail),
      TasksScreen(tasks: widget.appState.tasks, onUpdate: () => widget.appState.notify(), onTaskTap: _openTaskDetail),
      CalendarScreen(tasks: widget.appState.tasks, onTaskTap: _openTaskDetail),
      StatsScreen(tasks: widget.appState.tasks),
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Task Planner')),
      body: screens[_selectedIndex],
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