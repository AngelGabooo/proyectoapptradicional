import '../entities/task.dart';

abstract class TaskRepository {
  Future<List<Task>> getTasks();
  Future<Task> createTask(String title, String description);
  Future<Task> updateTask(Task task);
  Future<void> deleteTask(String id);
}