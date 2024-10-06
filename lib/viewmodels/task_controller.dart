import 'package:get/get.dart';
import '../models/task.dart';
import '../database/task_repository.dart'; // Database logic

class TaskController extends GetxController {
  var taskList = <Task>[].obs; // Observable list
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadTasks();
  }

  void loadTasks() async {
    isLoading(true);
    var tasks = await TaskRepository.getTasks();
    taskList.assignAll(tasks);
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

  List<Task> searchTasks(String query) {
    return taskList.where((task) => task.title.contains(query)).toList();
  }

  void sortTasksByPriority() {
    taskList.sort((a, b) => a.priority.compareTo(b.priority));
  }

  void sortTasksByDueDate() {
    taskList.sort((a, b) => a.dueDate.compareTo(b.dueDate));
  }
}
