import 'package:get/get.dart';
import '../models/task.dart';
import '../database/task_repository.dart'; // Database logic

class TaskController extends GetxController {
  var taskList = <Task>[].obs; // Observable list
  var isLoading = true.obs;
  var sortBy = 'priority'.obs; // Observable sorting criteria

  @override
  void onInit() {
    super.onInit();
    loadTasks();
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
    loadTasks();
  }

  void deleteTask(int id) async {
    await TaskRepository.deleteTask(id);
    loadTasks();
  }

  void updateTask(Task task) async {
    await TaskRepository.updateTask(task);
    loadTasks();
  }

  void toggleTaskCompletion(Task task) {
    task.isCompleted = !task.isCompleted; // Toggle completion status
    TaskRepository.updateTask(task); // Update task in the repository
    taskList.refresh(); // Refresh task list to update UI
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
}
