import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../viewmodels/task_controller.dart';
import 'task_search_delegate.dart';
import 'AddEditTaskScreen.dart';

class HomeScreen extends StatelessWidget {
  final TaskController taskController = Get.put(TaskController());

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
                delegate:
                    TaskSearchDelegate(), // Use the new TaskSearchDelegate
              );
            },
          ),
        ],
      ),
      body: Obx(() {
        if (taskController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
            itemCount: taskController.taskList.length,
            itemBuilder: (context, index) {
              final task = taskController.taskList[index];
              return ListTile(
                title: Text(task.title),
                subtitle:
                    Text('Due: ${task.dueDate} - Priority: ${task.priority}'),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    taskController.deleteTask(task.id!);
                  },
                ),
                onTap: () {
                  Get.to(() =>
                      AddEditTaskScreen(task: task)); // Navigate to edit screen
                },
              );
            },
          );
        }
      }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Get.to(() => AddEditTaskScreen()); // Navigate to Add Task Screen
        },
      ),
    );
  }
}
