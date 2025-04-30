import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_service.dart';

class TasksProvider with ChangeNotifier {
  final TaskService _taskService = TaskService();
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  void fetchTasks() {
    _taskService.getTasks().listen((tasks) {
      _tasks = tasks;
      notifyListeners();
    });
  }

  void addTask(Task task) async {
    await _taskService.addTask(task);
    await _taskService.cacheTask(task);
  }
}
