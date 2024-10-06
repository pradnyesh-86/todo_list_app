import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../viewmodels/task_controller.dart';
import 'task_search_delegate.dart';
import 'AddEditTaskScreen.dart';

class HomeScreen extends StatelessWidget {
  final TaskController taskController = Get.put(TaskController());

  // Method to determine the background color based on task priority
  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red.withOpacity(0.1); // Light red for high priority
      case 'Medium':
        return Colors.orange
            .withOpacity(0.1); // Light orange for medium priority
      case 'Low':
        return Colors.green.withOpacity(0.1); // Light green for low priority
      default:
        return Colors.grey.withOpacity(0.1); // Default light gray
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: TaskSearchDelegate(),
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              taskController.setSortBy(value);
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: 'priority',
                  child: Text('Sort by Priority'),
                ),
                PopupMenuItem(
                  value: 'dueDate',
                  child: Text('Sort by Due Date'),
                ),
                PopupMenuItem(
                  value: 'createdAt',
                  child: Text('Sort by Created At'),
                ),
              ];
            },
            icon: Icon(Icons.sort),
          ),
        ],
      ),
      body: Obx(() {
        if (taskController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else if (taskController.taskList.isEmpty) {
          // If the task list is empty, display a message
          return Center(
            child: Text(
              'No tasks available. Please add a new task.',
              style: TextStyle(fontSize: 18, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          );
        } else {
          return ListView.builder(
            itemCount: taskController.taskList.length,
            itemBuilder: (context, index) {
              final task = taskController.taskList[index];
              return Container(
                margin: EdgeInsets.symmetric(
                    vertical: 8.0, horizontal: 16.0), // Margin for spacing
                decoration: BoxDecoration(
                  color: _getPriorityColor(
                      task.priority), // Background color based on priority
                  borderRadius: BorderRadius.circular(12.0), // Rounded edges
                ),
                child: ListTile(
                  title: Text(
                    task.title,
                    style: TextStyle(
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  subtitle:
                      Text('Due: ${task.dueDate} - Priority: ${task.priority}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: task.isCompleted,
                        onChanged: (newValue) {
                          taskController.toggleTaskCompletion(task);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          taskController.deleteTask(task.id!);
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    Get.to(() => AddEditTaskScreen(task: task));
                  },
                ),
              );
            },
          );
        }
      }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Get.to(() => AddEditTaskScreen());
        },
      ),
    );
  }
}
