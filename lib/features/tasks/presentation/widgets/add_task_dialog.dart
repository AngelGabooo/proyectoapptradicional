// lib/features/tasks/presentation/widgets/add_task_dialog.dart
import 'package:flutter/material.dart';

class AddTaskDialog extends StatefulWidget {
  final Function(String title, String description) onAdd;

  const AddTaskDialog({
    super.key,
    required this.onAdd,
  });

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;

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
          Icon(Icons.add_task, color: colorScheme.primary),
          const SizedBox(width: 8),
          const Text('Nueva Tarea'),
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
              hintText: '¿Qué necesitas hacer?',
              prefixIcon: Icon(Icons.title),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Descripción',
              hintText: 'Detalles adicionales...',
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
              await widget.onAdd(
                _titleController.text.trim(),
                _descriptionController.text.trim(),
              );
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
              : const Text('Crear'),
        ),
      ],
    );
  }
}