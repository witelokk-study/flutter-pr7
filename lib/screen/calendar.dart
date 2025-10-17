import 'package:flutter/material.dart';
import '../task.dart';
import 'package:table_calendar/table_calendar.dart';


class CalendarScreen extends StatefulWidget {
  final List<Task> tasks;
  final Function(Task) onTaskTap;

  CalendarScreen({required this.tasks, required this.onTaskTap});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  Map<DateTime, List<Task>> _groupedTasks = {};

  @override
  void initState() {
    super.initState();
    _groupTasks();
    _selectedDay = _focusedDay;
  }

  void _groupTasks() {
    _groupedTasks.clear();
    for (var task in widget.tasks) {
      final day = DateTime(task.date.year, task.date.month, task.date.day);
      if (_groupedTasks[day] == null) {
        _groupedTasks[day] = [];
      }
      _groupedTasks[day]!.add(task);
    }
  }

  List<Task> _tasksForDay(DateTime day) {
    final date = DateTime(day.year, day.month, day.day);
    return _groupedTasks[date] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar<Task>(
          firstDay: DateTime(2020),
          lastDay: DateTime(2100),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          calendarFormat: CalendarFormat.month,
          eventLoader: _tasksForDay,
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          calendarStyle: CalendarStyle(
            markersMaxCount: 3,
            markerDecoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: _buildTaskList(),
        ),
      ],
    );
  }

  Widget _buildTaskList() {
    if (_selectedDay == null) return Center(child: Text('Выберите дату'));
    final tasks = _tasksForDay(_selectedDay!);
    if (tasks.isEmpty) return Center(child: Text('Задач на этот день нет'));
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return ListTile(
          title: Text(task.title),
          subtitle: Text(task.description),
          trailing: Checkbox(
            value: task.completed,
            onChanged: (val) {
              setState(() {
                task.completed = val ?? false;
              });
            },
          ),
          onTap: () => widget.onTaskTap(task),
        );
      },
    );
  }
}