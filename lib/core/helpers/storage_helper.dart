// lib/core/helpers/storage_helper.dart
import '../constants/app_constants.dart';

class StorageHelper {
  static final Map<String, String> _storage = {};

  static Future<void> saveToken(String token) async {
    _storage[AppConstants.tokenKey] = token;
  }

  static Future<String?> getToken() async {
    return _storage[AppConstants.tokenKey];
  }

  static Future<void> saveUser(String userJson) async {
    _storage[AppConstants.userKey] = userJson;
  }

  static Future<String?> getUser() async {
    return _storage[AppConstants.userKey];
  }

  static Future<void> clearAll() async {
    _storage.clear();
  }

  // Cambiamos la lógica: ahora consideramos logueado si hay usuario guardado
  static Future<bool> isLoggedIn() async {
    return _storage[AppConstants.userKey] != null;
  }
}