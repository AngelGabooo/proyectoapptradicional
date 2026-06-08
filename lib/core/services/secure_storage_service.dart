import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static final SecureStorageService _instance = SecureStorageService._internal();
  factory SecureStorageService() => _instance;
  SecureStorageService._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const String _keyToken = 'auth_token';
  static const String _keyUserId = 'user_id';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserName = 'user_name';
  static const String _keyLastActivity = 'last_activity_timestamp';
  static const String _keySessionActive = 'session_active';

  Future<void> saveToken(String token) async {
    await _storage.write(key: _keyToken, value: token);
    print('🔐 Token guardado encriptado');
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _keyToken);
  }

  Future<void> saveUserInfo({required String id, required String email, required String name}) async {
    await _storage.write(key: _keyUserId, value: id);
    await _storage.write(key: _keyUserEmail, value: email);
    await _storage.write(key: _keyUserName, value: name);
    print('🔐 Info usuario guardada encriptada');
  }

  Future<Map<String, String?>> getUserInfo() async {
    final id = await _storage.read(key: _keyUserId);
    final email = await _storage.read(key: _keyUserEmail);
    final name = await _storage.read(key: _keyUserName);
    return {
      'id': id,
      'email': email,
      'name': name,
    };
  }

  Future<void> saveLastActivity(DateTime timestamp) async {
    final timestampStr = timestamp.millisecondsSinceEpoch.toString();
    await _storage.write(key: _keyLastActivity, value: timestampStr);
    print('⏰ Última actividad guardada: ${timestamp.toString()}');
  }

  Future<DateTime?> getLastActivity() async {
    final timestampStr = await _storage.read(key: _keyLastActivity);
    if (timestampStr != null) {
      return DateTime.fromMillisecondsSinceEpoch(int.parse(timestampStr));
    }
    return null;
  }

  Future<void> setSessionActive(bool active) async {
    await _storage.write(key: _keySessionActive, value: active.toString());
  }

  Future<bool> isSessionActive() async {
    final value = await _storage.read(key: _keySessionActive);
    return value == 'true';
  }

  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> clearAll() async {
    await _storage.delete(key: _keyToken);
    await _storage.delete(key: _keyUserId);
    await _storage.delete(key: _keyUserEmail);
    await _storage.delete(key: _keyUserName);
    await _storage.delete(key: _keyLastActivity);
    await _storage.delete(key: _keySessionActive);
    print('🗑️ Todos los datos encriptados eliminados');
  }
}