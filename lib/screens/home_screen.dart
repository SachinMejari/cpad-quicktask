import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/task_item.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'task_screen.dart'; // Import the TaskScreen

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<void> _fetchTasksFuture;

  @override
  void initState() {
    super.initState();
    _fetchTasksFuture = _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    final currentUser = await ParseUser.currentUser() as ParseUser?;
    if (currentUser != null) {
      final userId = currentUser.objectId!;
      await Provider.of<TaskProvider>(context, listen: false)
          .fetchTasks(userId);
    }
  }

  void _addNewTask() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TaskScreen(),
      ),
    );
  }

  void _refreshTasks() {
    setState(() {
      _fetchTasksFuture = _fetchTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshTasks,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final user = await ParseUser.currentUser() as ParseUser?;
              if (user != null) {
                await user.logout();
                Navigator.of(context).pushReplacementNamed('/login');
              }
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _fetchTasksFuture,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (taskProvider.tasks.isEmpty) {
            return const Center(child: Text('No tasks available!'));
          }

          return ListView.builder(
            itemCount: taskProvider.tasks.length,
            itemBuilder: (ctx, i) => TaskItem(task: taskProvider.tasks[i]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}
