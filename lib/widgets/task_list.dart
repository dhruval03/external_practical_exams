import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tasks_provider.dart';
import 'task_item.dart';

class TaskList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TasksProvider>(context);

    return ListView.builder(
      itemCount: provider.tasks.length,
      itemBuilder: (ctx, index) {
        return TaskItem(task: provider.tasks[index]);
      },
    );
  }
}
