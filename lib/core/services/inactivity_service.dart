import 'dart:async';
import 'package:flutter/material.dart';
import 'secure_storage_service.dart';

class InactivityService {
  static final InactivityService _instance = InactivityService._internal();
  factory InactivityService() => _instance;
  InactivityService._internal();

  Timer? _inactivityTimer;
  VoidCallback? _onLogout;
  bool _isLoggingOut = false;

  static const int _inactivityTimeoutMinutes = 1;
  static const int _inactivityTimeoutSeconds = _inactivityTimeoutMinutes * 60;

  final SecureStorageService _secureStorage = SecureStorageService();

  Future<void> initialize(VoidCallback onLogout) async {
    _onLogout = onLogout;

    final isSessionValid = await _checkSessionValidity();

    if (!isSessionValid && await _secureStorage.isSessionActive()) {
      print('⏰ Sesión expirada durante el cierre');
      await _performLogout();
    } else if (isSessionValid) {
      await resetTimer();
    }
  }

  Future<bool> _checkSessionValidity() async {
    final lastActivity = await _secureStorage.getLastActivity();
    if (lastActivity == null) return false;

    final now = DateTime.now();
    final difference = now.difference(lastActivity);
    final isExpired = difference.inSeconds >= _inactivityTimeoutSeconds;

    if (isExpired) {
      print('⏰ Sesión expirada: ${difference.inMinutes} minutos sin actividad');
      return false;
    }

    return true;
  }

  Future<void> resetTimer() async {
    if (_isLoggingOut) return;

    await _updateLastActivity();

    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(const Duration(seconds: _inactivityTimeoutSeconds), () {
      _performLogout();
    });
  }

  Future<void> _updateLastActivity() async {
    await _secureStorage.saveLastActivity(DateTime.now());
  }

  Future<void> _performLogout() async {
    if (_isLoggingOut) return;
    _isLoggingOut = true;

    print('🚪 Cerrando sesión por inactividad');

    _inactivityTimer?.cancel();
    await _secureStorage.setSessionActive(false);

    if (_onLogout != null) {
      _onLogout!();
    }

    _isLoggingOut = false;
  }

  void dispose() {
    _inactivityTimer?.cancel();
    _onLogout = null;
    _isLoggingOut = false;
  }

  Future<void> startSession(String token, String userId, String email, String name) async {
    await _secureStorage.saveToken(token);
    await _secureStorage.saveUserInfo(id: userId, email: email, name: name);
    await _secureStorage.setSessionActive(true);
    await _updateLastActivity();
    await resetTimer();
    print('🚀 Sesión iniciada con almacenamiento encriptado');
  }

  Future<void> clearSession() async {
    await _secureStorage.clearAll();
    dispose();
    print('🧹 Sesión encriptada limpiada');
  }

  Future<bool> hasValidSession() async {
    final hasToken = await _secureStorage.hasToken();
    final isActive = await _secureStorage.isSessionActive();

    if (!hasToken || !isActive) return false;

    return await _checkSessionValidity();
  }
}