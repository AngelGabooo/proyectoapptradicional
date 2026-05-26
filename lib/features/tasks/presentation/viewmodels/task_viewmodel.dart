import 'package:flutter/material.dart';
import '../../../domain/entities/task.dart';
import '../../../domain/repositories/task_repository.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';

class TaskViewModel extends ChangeNotifier {
  final TaskRepository repository;

  TaskViewModel(this.repository);

  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _error;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get pendingCount => _tasks.where((t) => !t.isCompleted).length;
  int get completedCount => _tasks.where((t) => t.isCompleted).length;

  Future<void> loadTasks() async {
    _setLoading(true);
    _clearError();

    try {
      _tasks = await repository.getTasks();
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  Future<bool> addTask(String title, String description) async {
    _setLoading(true);

    try {
      final newTask = await repository.createTask(title, description);
      _tasks.add(newTask);
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  Future<bool> toggleTask(Task task) async {
    try {
      final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
      final result = await repository.updateTask(updatedTask);

      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = result;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  Future<bool> updateTask(Task task) async {
    try {
      final updatedTask = await repository.updateTask(task);
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = updatedTask;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  Future<bool> deleteTask(String id) async {
    try {
      await repository.deleteTask(id);
      _tasks.removeWhere((task) => task.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String value) {
    _error = value;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }
}