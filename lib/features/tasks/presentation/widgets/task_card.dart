import 'package:flutter/material.dart';
import '../../../domain/entities/task.dart';
import '../../domain/entities/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TaskCard({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Dismissible(
        key: Key(task.id),
        direction: DismissDirection.endToStart,
        background: _buildDismissBackground(context),
        onDismissed: (_) => onDelete(),
        child: ListTile(
          leading: Checkbox(
            value: task.isCompleted,
            onChanged: (_) => onToggle(),
            activeColor: colorScheme.secondary,
          ),
          title: Text(
            task.title,
            style: TextStyle(
              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
              fontWeight: FontWeight.w500,
              color: task.isCompleted
                  ? (isDark ? Colors.grey.shade600 : Colors.grey.shade500)
                  : (isDark ? Colors.white : Colors.black87),
            ),
          ),
          subtitle: task.description.isNotEmpty
              ? Text(
            task.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
            ),
          )
              : null,
          trailing: IconButton(
            icon: Icon(Icons.edit, color: colorScheme.primary),
            onPressed: onEdit,
          ),
        ),
      ),
    );
  }

  Widget _buildDismissBackground(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: isDark ? Colors.red.shade700 : Colors.red,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.delete, color: Colors.white),
    );
  }
}