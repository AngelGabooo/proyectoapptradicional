import '../models/task_model.dart';
import '../../../../core/helpers/http_helper.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/helpers/storage_helper.dart';

class TaskDatasource {
  final HttpHelper httpHelper = HttpHelper();

  Future<String?> _getUserId() async {
    return await StorageHelper.getUserId();
  }

  Future<List<TaskModel>> getTasks() async {
    try {
      final response = await httpHelper.get(AppConstants.tasksEndpoint);
      print('📥 getTasks response: $response');

      if (response == null) return [];

      final List<dynamic> data = response;
      return data.map((json) => TaskModel.fromJson(json)).toList();
    } catch (e) {
      print('❌ Error en getTasks: $e');
      return [];
    }
  }

  Future<TaskModel> createTask(String title, String description) async {
    final userId = await _getUserId();
    print('📝 Creando tarea - userId: $userId, title: $title');

    if (userId == null) {
      throw Exception('Usuario no autenticado. No se puede crear tarea.');
    }

    final response = await httpHelper.post(AppConstants.tasksEndpoint, {
      'title': title,
      'description': description,
      'userId': userId,
    });

    print('✅ createTask response: $response');
    return TaskModel.fromJson(response);
  }

  Future<TaskModel> updateTask(TaskModel task) async {
    final response = await httpHelper.put(
      '${AppConstants.tasksEndpoint}/${task.id}',
      task.toJson(),
    );
    return TaskModel.fromJson(response);
  }

  Future<void> deleteTask(String id) async {
    await httpHelper.delete('${AppConstants.tasksEndpoint}/$id');
  }
}