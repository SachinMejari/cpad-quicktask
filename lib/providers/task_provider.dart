import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  // Fetch tasks from the server
  Future<void> fetchTasks(String userId) async {
    final query = QueryBuilder<ParseObject>(ParseObject('Task'))
      ..whereEqualTo('userId', userId);

    final response = await query.query();

    if (response.success && response.results != null) {
      _tasks = response.results!.map((e) => Task.fromParseObject(e)).toList();
      notifyListeners();
    }
  }

  // Add a new task
  Future<void> addTask(String title, DateTime dueDate, String userId) async {
    final task = ParseObject('Task')
      ..set('title', title)
      ..set('dueDate', dueDate)
      ..set('completed', false)
      ..set('userId', userId); // Set userId to provided userId

    final response = await task.save();

    if (response.success) {
      _tasks.add(Task.fromParseObject(response.result));
      notifyListeners();
    }
  }

  // Update an existing task
  Future<void> updateTask(
      String taskId, String title, DateTime dueDate, String userId) async {
    final task = ParseObject('Task')..objectId = taskId;
    task.set('title', title);
    task.set('dueDate', dueDate.toUtc());
    task.set('userId', userId); // Ensure userId is updated

    final response = await task.save();

    if (response.success) {
      final index = _tasks.indexWhere((t) => t.id == taskId);
      if (index != -1) {
        _tasks[index] = Task.fromParseObject(response.result);
      }
      notifyListeners();
    }
  }

  // Delete a task
  Future<void> deleteTask(String taskId) async {
    final task = ParseObject('Task')..objectId = taskId;
    final response = await task.delete();

    if (response.success) {
      _tasks.removeWhere((t) => t.id == taskId);
      notifyListeners();
    }
  }

  // Toggle task status
  Future<void> toggleTaskStatus(String taskId, bool currentStatus) async {
    final task = ParseObject('Task')..objectId = taskId;
    task.set('completed', !currentStatus);

    final response = await task.save();

    if (response.success) {
      final index = _tasks.indexWhere((t) => t.id == taskId);
      _tasks[index] = Task(
        id: _tasks[index].id,
        title: _tasks[index].title,
        dueDate: _tasks[index].dueDate,
        completed: !currentStatus,
        userId: _tasks[index].userId, // Ensure userId is retained
      );
      notifyListeners();
    }
  }
}
