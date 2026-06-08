import 'package:flutter/material.dart';
import '../../../domain/entities/task.dart';
import '../../domain/entities/task.dart';
import 'task_card.dart';

class TaskList extends StatelessWidget {
  final List<Task> tasks;
  final Function(Task) onToggle;
  final Function(Task) onEdit;
  final Function(String) onDelete;

  const TaskList({
    super.key,
    required this.tasks,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return TaskCard(
          task: task,
          onToggle: () => onToggle(task),
          onEdit: () => onEdit(task),
          onDelete: () => onDelete(task.id),
        );
      },
    );
  }
}