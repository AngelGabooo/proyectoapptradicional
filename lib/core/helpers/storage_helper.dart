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

  static Future<void> saveUserId(String userId) async {
    _storage['user_id'] = userId;
    print('💾 userId guardado: $userId');
  }

  static Future<String?> getUserId() async {
    final userId = _storage['user_id'];
    print('📖 Obteniendo userId: $userId');
    return userId;
  }

  static Future<void> clearAll() async {
    _storage.clear();
    print('🗑️ Storage limpiado');
  }

  static Future<bool> isLoggedIn() async {
    return _storage[AppConstants.userKey] != null;
  }
}