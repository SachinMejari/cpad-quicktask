import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class Task {
  final String id;
  final String title;
  final DateTime dueDate;
  final bool completed;
  final String userId; // Add userId field

  Task({
    required this.id,
    required this.title,
    required this.dueDate,
    required this.completed,
    required this.userId, // Add userId to constructor
  });

  factory Task.fromParseObject(ParseObject parseObject) {
    return Task(
      id: parseObject.objectId!,
      title: parseObject.get<String>('title')!,
      dueDate: parseObject.get<DateTime>('dueDate') ?? DateTime.now(),
      completed: parseObject.get<bool>('completed') ?? false,
      userId: parseObject.get<String>('userId')!, // Get userId from ParseObject
    );
  }

  ParseObject toParseObject() {
    final task = ParseObject('Task')
      ..set('title', title)
      ..set('dueDate', dueDate)
      ..set('completed', completed)
      ..set('userId', userId); // Set userId field
    if (id.isNotEmpty) {
      task.objectId = id;
    }
    return task;
  }
}
