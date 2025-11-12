import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../task.dart';
import 'package:intl/intl.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task;
  final VoidCallback onUpdate;

  TaskDetailScreen({required this.task, required this.onUpdate});

  @override
  _TaskDetailScreenState createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late DateTime _date;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descController = TextEditingController(text: widget.task.description);
    _date = widget.task.date;
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _date) {
      setState(() {
        _date = picked;
      });
    }
  }

  void _save() {
    widget.task.title = _titleController.text;
    widget.task.description = _descController.text;
    widget.task.date = _date;
    widget.onUpdate();
    
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
        title: Text('Детали задачи'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Название'),
            ),
            TextField(
              controller: _descController,
              decoration: InputDecoration(labelText: 'Описание'),
            ),
            Row(
              children: [
                Text('Дата: ${DateFormat('dd.MM.yyyy').format(_date)}'),
                TextButton.icon(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _pickDate(context),
                  label: Text('Выбрать дату'),
                ),
              ],
            ),
            CheckboxListTile(
              title: Text('Выполнено'),
              value: widget.task.completed,
              onChanged: (val) {
                setState(() {
                  widget.task.completed = val ?? false;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _save, child: Text('Сохранить')),
          ],
        ),
      ),
    );
  }
}
