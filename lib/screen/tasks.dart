import 'package:flutter/material.dart';
import '../task.dart';
import 'package:intl/intl.dart';

class TasksScreen extends StatefulWidget {
  final List<Task> tasks;
  final VoidCallback onUpdate;
  final Function(int) onTaskTap;

  TasksScreen({required this.tasks, required this.onUpdate, required this.onTaskTap});

  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final TextEditingController _controllerTitle = TextEditingController();
  final TextEditingController _controllerDesc = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  void _addTask() {
    if (_controllerTitle.text.isEmpty) return;
    widget.tasks.add(Task(title: _controllerTitle.text, description: _controllerDesc.text, date: _selectedDate));
    _controllerTitle.clear();
    _controllerDesc.clear();
    widget.onUpdate();
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context, initialDate: _selectedDate, firstDate: DateTime(2020), lastDate: DateTime(2100));
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Задачи')),
      body: Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _controllerTitle,
                decoration: InputDecoration(labelText: 'Название задачи'),
              ),
              TextField(
                controller: _controllerDesc,
                decoration: InputDecoration(labelText: 'Описание'),
              ),
              Row(
                children: [
                  TextButton.icon(icon: Icon(Icons.calendar_today), label: Text('Выбрать дату'), onPressed: () => _pickDate(context)),
                  Spacer(),
                  ElevatedButton.icon(icon: Icon(Icons.add), label: Text('Добавить'), onPressed: _addTask),
                ],
              )
            ],
          ),
        ),
        Expanded(
          child: ListView(
            children: widget.tasks.map((task) {
              return CheckboxListTile(
                title: Text('${task.title} (${DateFormat('dd.MM.yyyy').format(task.date)})'),
                subtitle: Text(task.description),
                value: task.completed,
                onChanged: (val) {
                  setState(() {
                    task.completed = val ?? false;
                  });
                  widget.onUpdate();
                },
                secondary: IconButton(icon: Icon(Icons.info), onPressed: () {
                  final idx = widget.tasks.indexOf(task);
                  widget.onTaskTap(idx);
                }),
              );
            }).toList(),
          ),
        ),
      ],
    ),
    );
  }
}