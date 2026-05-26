import '../../../domain/entities/task.dart';
import '../../../domain/repositories/task_repository.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_datasource.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskDatasource datasource;

  TaskRepositoryImpl(this.datasource);

  @override
  Future<List<Task>> getTasks() async {
    final tasks = await datasource.getTasks();
    return tasks.map((task) => task.toEntity()).toList();
  }

  @override
  Future<Task> createTask(String title, String description) async {
    final task = await datasource.createTask(title, description);
    return task.toEntity();
  }

  @override
  Future<Task> updateTask(Task task) async {
    final updatedTask = await datasource.updateTask(TaskModel.fromEntity(task));
    return updatedTask.toEntity();
  }

  @override
  Future<void> deleteTask(String id) async {
    await datasource.deleteTask(id);
  }
}