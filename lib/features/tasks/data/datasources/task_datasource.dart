// lib/features/tasks/data/datasources/task_datasource.dart
import '../models/task_model.dart';
import '../../../../core/helpers/http_helper.dart';
import '../../../../core/constants/app_constants.dart';

class TaskDatasource {
  final HttpHelper httpHelper = HttpHelper();

  // ✅ VERSIÓN REAL (API en VSCode)
  Future<List<TaskModel>> getTasks() async {
    final response = await httpHelper.get(AppConstants.tasksEndpoint);
    final List<dynamic> data = response;
    return data.map((json) => TaskModel.fromJson(json)).toList();
  }

  Future<TaskModel> createTask(String title, String description) async {
    final response = await httpHelper.post(AppConstants.tasksEndpoint, {
      'title': title,
      'description': description,
    });
    return TaskModel.fromJson(response);
  }

  Future<TaskModel> updateTask(TaskModel task) async {
    final response = await httpHelper.put(
        '${AppConstants.tasksEndpoint}/${task.id}',
        task.toJson()
    );
    return TaskModel.fromJson(response);
  }

  Future<void> deleteTask(String id) async {
    await httpHelper.delete('${AppConstants.tasksEndpoint}/$id');
  }

// 🗃️ MOCK DATA (comentado - para pruebas sin servidor)
/*
  static List<TaskModel> _mockTasks = [];

  TaskDatasource() {
    if (_mockTasks.isEmpty) {
      _mockTasks = [
        TaskModel(
          id: '1',
          title: 'Aprender Flutter',
          description: 'Completar el curso de Flutter y Clean Architecture',
          isCompleted: false,
          createdAt: DateTime.now(),
        ),
        TaskModel(
          id: '2',
          title: 'Hacer la app TaskFlow',
          description: 'Implementar CRUD con Provider y Material 3',
          isCompleted: false,
          createdAt: DateTime.now(),
        ),
      ];
    }
  }

  Future<List<TaskModel>> getTasks() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockTasks;
  }

  Future<TaskModel> createTask(String title, String description) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final newTask = TaskModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      isCompleted: false,
      createdAt: DateTime.now(),
    );
    _mockTasks.add(newTask);
    return newTask;
  }

  Future<TaskModel> updateTask(TaskModel task) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _mockTasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _mockTasks[index] = task;
      return task;
    }
    throw Exception('Task no encontrada');
  }

  Future<void> deleteTask(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockTasks.removeWhere((task) => task.id == id);
  }
  */
}