import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quicktask/screens/task_screen.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

class TaskItem extends StatelessWidget {
  final Task task;

  const TaskItem({required this.task, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    final formattedDate = DateFormat.yMMMd()
        .format(task.dueDate.toLocal()); // Convert to local timezone

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            // Navigate to the task edit screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctx) =>
                    TaskScreen(task: task), // Pass the task to edit
              ),
            );
          },
          child: ListTile(
            title: Text(
              task.title,
              style: TextStyle(
                decoration: task.completed ? TextDecoration.lineThrough : null,
              ),
            ),
            subtitle: Text('Due: $formattedDate'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    task.completed
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                  ),
                  onPressed: () =>
                      taskProvider.toggleTaskStatus(task.id, task.completed),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => taskProvider.deleteTask(task.id),
                ),
              ],
            ),
          ),
        ),
        const Divider(
          color: Colors.grey, // Adjust color to match your theme
          thickness: 1.0, // Adjust thickness
          indent: 16.0, // Left padding
          endIndent: 16.0, // Right padding
        ),
      ],
    );
  }
}
