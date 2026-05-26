// lib/features/tasks/presentation/widgets/edit_task_dialog.dart
import 'package:flutter/material.dart';
import '../../../domain/entities/task.dart';
import '../../domain/entities/task.dart';

class EditTaskDialog extends StatefulWidget {
  final Task task;
  final Function(Task) onEdit;

  const EditTaskDialog({
    super.key,
    required this.task,
    required this.onEdit,
  });

  @override
  State<EditTaskDialog> createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<EditTaskDialog> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(text: widget.task.description);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.edit, color: colorScheme.primary),
          const SizedBox(width: 8),
          const Text('Editar Tarea'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Título',
              prefixIcon: Icon(Icons.title),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Descripción',
              prefixIcon: Icon(Icons.description),
            ),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _isLoading
              ? null
              : () async {
            if (_titleController.text.trim().isNotEmpty) {
              setState(() => _isLoading = true);
              final updatedTask = widget.task.copyWith(
                title: _titleController.text.trim(),
                description: _descriptionController.text.trim(),
              );
              await widget.onEdit(updatedTask);
              if (mounted) {
                Navigator.pop(context);
              }
            }
          },
          child: _isLoading
              ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
              : const Text('Guardar'),
        ),
      ],
    );
  }
}