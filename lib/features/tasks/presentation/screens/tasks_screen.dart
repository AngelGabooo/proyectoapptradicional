// lib/features/tasks/presentation/screens/tasks_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/task_viewmodel.dart';
import '../../../../features/auth/presentation/viewmodels/auth_viewmodel.dart';
import '../../../../features/auth/presentation/screens/login_screen.dart';
import '../widgets/task_stats.dart';
import '../widgets/task_list.dart';
import '../widgets/empty_tasks_view.dart';
import '../widgets/add_task_dialog.dart';
import '../widgets/edit_task_dialog.dart';
import '../../../../core/widgets/loading_indicator.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskViewModel>().loadTasks();
    });
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) => AddTaskDialog(
        onAdd: (title, description) async {
          await context.read<TaskViewModel>().addTask(title, description);
        },
      ),
    );
  }

  void _showEditDialog(TaskViewModel viewModel, task) {
    showDialog(
      context: context,
      builder: (context) => EditTaskDialog(
        task: task,
        onEdit: (updatedTask) async {
          await viewModel.updateTask(updatedTask);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskViewModel = context.watch<TaskViewModel>();
    final authViewModel = context.watch<AuthViewModel>();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Tareas'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authViewModel.logout();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              }
            },
            tooltip: 'Cerrar sesión',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: TaskStats(
            pendingCount: taskViewModel.pendingCount,
            completedCount: taskViewModel.completedCount,
          ),
        ),
      ),
      body: _buildBody(taskViewModel),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddTaskDialog,
        icon: const Icon(Icons.add),
        label: const Text('Nueva Tarea'),
        backgroundColor: colorScheme.primary,
      ),
    );
  }

  Widget _buildBody(TaskViewModel viewModel) {
    if (viewModel.isLoading && viewModel.tasks.isEmpty) {
      return const LoadingIndicator();
    }

    if (viewModel.tasks.isEmpty) {
      return EmptyTasksView(
        onAddPressed: _showAddTaskDialog,
      );
    }

    return TaskList(
      tasks: viewModel.tasks,
      onToggle: (task) => viewModel.toggleTask(task),
      onEdit: (task) => _showEditDialog(viewModel, task),
      onDelete: (id) => viewModel.deleteTask(id),
    );
  }
}