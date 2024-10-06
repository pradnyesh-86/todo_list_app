import 'package:get/get.dart';
import '../models/task.dart';
import '../database/task_repository.dart'; // Database logic
import '../services/notification_service.dart'; // Import Notification Service

class TaskController extends GetxController {
  var taskList = <Task>[].obs; // Observable list
  var isLoading = true.obs;
  var sortBy = 'priority'.obs; // Observable sorting criteria

  @override
  void onInit() {
    super.onInit();
    loadTasks();
    NotificationService().initNotification(); // Initialize notifications
  }

  void loadTasks() async {
    isLoading(true);
    var tasks = await TaskRepository.getTasks();
    taskList.assignAll(tasks);
    sortTasks(); // Sort the tasks after loading
    isLoading(false);
  }

  void addTask(Task task) async {
    await TaskRepository.insertTask(task);
    scheduleNotificationForTask(task); // Schedule notification
    loadTasks();
  }

  void deleteTask(int id) async {
    await TaskRepository.deleteTask(id);
    NotificationService()
        .cancelNotification(id); // Cancel notification on delete
    loadTasks();
  }

  void updateTask(Task task) async {
    await TaskRepository.updateTask(task);
    scheduleNotificationForTask(
        task); // Update notification for the updated task
    loadTasks();
  }

  void toggleTaskCompletion(Task task) {
    task.isCompleted = !task.isCompleted; // Toggle completion status
    TaskRepository.updateTask(task); // Update task in the repository
    taskList.refresh(); // Refresh task list to update UI

    if (task.isCompleted) {
      NotificationService()
          .cancelNotification(task.id!); // Cancel notification if completed
    } else {
      scheduleNotificationForTask(task); // Reschedule if marked incomplete
    }
  }

  List<Task> searchTasks(String query) {
    return taskList.where((task) => task.title.contains(query)).toList();
  }

  void setSortBy(String value) {
    sortBy.value = value; // Set the new sorting criteria
    sortTasks(); // Sort tasks again with the new criteria
  }

  void sortTasks() {
    if (sortBy.value == 'priority') {
      sortTasksByPriority(); // Sort by priority
    } else if (sortBy.value == 'dueDate') {
      sortTasksByDueDate(); // Sort by due date
    } else if (sortBy.value == 'createdAt') {
      sortTasksByCreatedAt(); // Sort by creation date (using id as a proxy)
    }
  }

  void sortTasksByPriority() {
    taskList.sort((a, b) => a.priority.compareTo(b.priority));
  }

  void sortTasksByDueDate() {
    taskList.sort((a, b) => a.dueDate.compareTo(b.dueDate));
  }

  void sortTasksByCreatedAt() {
    taskList.sort((a, b) => (a.id ?? 0)
        .compareTo(b.id ?? 0)); // Use id as a proxy for creation date
  }

  // Schedule a notification for a task
  void scheduleNotificationForTask(Task task) {
    if (!task.isCompleted) {
      // Schedule notification if task is not completed
      try {
        NotificationService().scheduleNotification(
          task.id!,
          "Task Reminder",
          task.title,
          task.dueDate, // Schedule the notification at task's due date
        );
      } catch (e) {
        // Handle potential errors when scheduling notifications
        print('Failed to schedule notification: $e');
      }
    }
  }
}
