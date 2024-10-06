import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/task.dart';
import '../viewmodels/task_controller.dart';
import '../services/notification_service.dart';

class AddEditTaskScreen extends StatefulWidget {
  final Task? task; // Optional task for editing

  AddEditTaskScreen({this.task});

  @override
  _AddEditTaskScreenState createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final TaskController taskController = Get.find();
  final NotificationService notificationService =
      NotificationService(); // Initialize NotificationService

  // Controllers for text fields
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  // Variables for priority, date, and time
  String _selectedPriority = 'Low';
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now(); // Added Time Variable

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      _selectedPriority = widget.task!.priority;
      _selectedDate = widget.task!.dueDate;
      _selectedTime = TimeOfDay.fromDateTime(
          widget.task!.dueDate); // Convert DateTime to TimeOfDay
    }
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  // Combine the selected date and time
  DateTime _combineDateAndTime(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      DateTime dueDateTime = _combineDateAndTime(
          _selectedDate, _selectedTime); // Combine Date & Time

      if (widget.task != null) {
        // Edit existing task
        Task updatedTask = widget.task!.copyWith(
          title: _titleController.text,
          description: _descriptionController.text,
          dueDate: dueDateTime,
          priority: _selectedPriority,
        );
        taskController.updateTask(updatedTask);

        // Schedule notification for the updated task
        notificationService.scheduleNotification(
          updatedTask.id ?? 0, // Use task ID
          'Task Reminder',
          'Don\'t forget to complete your task: ${updatedTask.title}',
          dueDateTime,
        );
      } else {
        // Add new task
        Task newTask = Task(
          title: _titleController.text,
          description: _descriptionController.text,
          dueDate: dueDateTime, // Use combined date and time
          priority: _selectedPriority,
        );
        taskController.addTask(newTask);

        // Schedule notification for the new task
        notificationService.scheduleNotification(
          newTask.id ?? 0, // Ensure you have a valid ID
          'Task Reminder',
          'Don\'t forget to complete your task: ${newTask.title}',
          dueDateTime,
        );
      }
      Get.back(); // Navigate back after saving
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task != null ? 'Edit Task' : 'Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Task Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a task title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Task Description'),
              ),
              DropdownButtonFormField<String>(
                value: _selectedPriority,
                decoration: InputDecoration(labelText: 'Priority'),
                items: ['Low', 'Medium', 'High'].map((priority) {
                  return DropdownMenuItem(
                    value: priority,
                    child: Text(priority),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPriority = value!;
                  });
                },
              ),
              SizedBox(height: 20),
              ListTile(
                title:
                    Text('Due Date: ${_selectedDate.toLocal()}'.split(' ')[0]),
                trailing: Icon(Icons.calendar_today),
                onTap: _selectDate,
              ),
              ListTile(
                title: Text(
                    'Due Time: ${_selectedTime.format(context)}'), // Show selected time
                trailing: Icon(Icons.access_time),
                onTap: _selectTime, // Select time when tapped
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveTask,
                child: Text(widget.task != null ? 'Update Task' : 'Add Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
