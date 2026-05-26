// lib/features/auth/presentation/viewmodels/auth_viewmodel.dart
import 'package:flutter/material.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository repository;

  AuthViewModel(this.repository);

  bool _isLoading = false;
  String? _error;
  User? _currentUser;

  bool get isLoading => _isLoading;
  String? get error => _error;
  User? get currentUser => _currentUser;

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      _currentUser = await repository.login(email, password);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  Future<bool> register(String email, String password, String name) async {
    _setLoading(true);
    _clearError();

    try {
      _currentUser = await repository.register(email, password, name);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  Future<void> logout() async {
    await repository.logout();
    _currentUser = null;
    notifyListeners();
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