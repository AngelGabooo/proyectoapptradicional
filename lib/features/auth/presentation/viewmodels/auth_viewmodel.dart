import 'package:flutter/material.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../../core/services/inactivity_service.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository repository;
  final InactivityService _inactivityService = InactivityService();

  AuthViewModel(this.repository) {
    _initialize();
  }

  bool _isLoading = false;
  String? _error;
  User? _currentUser;

  bool get isLoading => _isLoading;
  String? get error => _error;
  User? get currentUser => _currentUser;

  Future<void> _initialize() async {
    await _inactivityService.initialize(() async {
      await _autoLogout();
    });

    final isValidSession = await _inactivityService.hasValidSession();
    if (isValidSession) {
      print('🔄 Recuperando sesión guardada');
      await _restoreSession();
    }
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      _currentUser = await repository.login(email, password);

      final token = await repository.getToken();
      if (token.isNotEmpty && _currentUser != null) {
        await _inactivityService.startSession(
          token,
          _currentUser!.id,
          _currentUser!.email,
          _currentUser!.name,
        );
      }

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

      final token = await repository.getToken();
      if (token.isNotEmpty && _currentUser != null) {
        await _inactivityService.startSession(
          token,
          _currentUser!.id,
          _currentUser!.email,
          _currentUser!.name,
        );
      }

      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  Future<void> logout() async {
    await _inactivityService.clearSession();
    await repository.logout();
    _currentUser = null;
    notifyListeners();
  }

  Future<void> _autoLogout() async {
    print('⏰ Auto-logout por inactividad');
    await repository.logout();
    _currentUser = null;
    notifyListeners();
  }

  Future<void> _restoreSession() async {
    try {
      final sessionData = await repository.restoreSession();
      final userInfo = sessionData['user'] as Map<String, String?>;

      if (userInfo['id'] != null && userInfo['email'] != null && userInfo['name'] != null) {
        _currentUser = User(
          id: userInfo['id']!,
          email: userInfo['email']!,
          name: userInfo['name']!,
        );
        print('✅ Sesión restaurada para usuario: ${_currentUser!.name}');
        notifyListeners();
      }
    } catch (e) {
      print('❌ Error restaurando sesión: $e');
    }
  }

  void resetInactivityTimer() {
    _inactivityService.resetTimer();
  }

  void stopInactivityTimer() {
    _inactivityService.dispose();
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

  @override
  void dispose() {
    _inactivityService.dispose();
    super.dispose();
  }
}