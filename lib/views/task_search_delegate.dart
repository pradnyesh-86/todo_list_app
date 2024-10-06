import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../viewmodels/task_controller.dart';
import '../models/task.dart';

class TaskSearchDelegate extends SearchDelegate {
  final TaskController taskController = Get.find();

  @override
  List<Widget>? buildActions(BuildContext context) {
    // Actions for app bar (like clear button)
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = ''; // Clear the search query
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // Leading icon on the left of the app bar (back button)
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); // Close search
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Show results based on the search query
    List<Task> results = taskController.searchTasks(query);
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final task = results[index];
        return ListTile(
          title: Text(task.title),
          subtitle: Text(task.description),
          onTap: () {
            // Do something when the task is tapped, like open details
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Show suggestions while typing
    List<Task> suggestions = taskController.searchTasks(query);

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final task = suggestions[index];
        return ListTile(
          title: Text(task.title),
          onTap: () {
            query = task.title; // Set the query to the selected suggestion
            showResults(context); // Show results for the selected suggestion
          },
        );
      },
    );
  }
}
