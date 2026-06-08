import 'dart:convert';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_datasource.dart';
import '../models/user_model.dart';
import '../../../../core/helpers/storage_helper.dart';
import '../../../../core/services/secure_storage_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource datasource;
  final SecureStorageService _secureStorage = SecureStorageService();

  AuthRepositoryImpl(this.datasource);

  @override
  Future<User> register(String email, String password, String name) async {
    try {
      final data = await datasource.register(email, password, name);
      print('🔍 Respuesta REGISTER: $data');

      final userData = data['user'];
      final token = data['token'];

      if (userData == null) {
        throw Exception('No se recibieron datos del usuario');
      }

      // ✅ Guardar en StorageHelper (existente)
      await StorageHelper.saveUser(jsonEncode(userData));
      await StorageHelper.saveUserId(userData['id'].toString());

      // ✅ Guardar en almacenamiento encriptado
      if (token != null) {
        await _secureStorage.saveToken(token);
      }
      await _secureStorage.saveUserInfo(
        id: userData['id'].toString(),
        email: userData['email'].toString(),
        name: userData['name'].toString(),
      );
      await _secureStorage.setSessionActive(true);
      await _secureStorage.saveLastActivity(DateTime.now());

      print('✅ Usuario registrado y guardado (encriptado). ID: ${userData['id']}');
      return UserModel.fromJson(userData as Map<String, dynamic>).toEntity();
    } catch (e) {
      print('❌ Error en register: $e');
      rethrow;
    }
  }

  @override
  Future<User> login(String email, String password) async {
    try {
      final data = await datasource.login(email, password);
      print('🔍 Respuesta LOGIN: $data');

      final userData = data['user'];
      final token = data['token'];

      if (userData == null) {
        throw Exception('No se recibieron datos del usuario');
      }

      // ✅ Guardar en StorageHelper
      await StorageHelper.saveUser(jsonEncode(userData));
      await StorageHelper.saveUserId(userData['id'].toString());

      // ✅ Guardar en almacenamiento encriptado
      if (token != null) {
        await _secureStorage.saveToken(token);
      }
      await _secureStorage.saveUserInfo(
        id: userData['id'].toString(),
        email: userData['email'].toString(),
        name: userData['name'].toString(),
      );
      await _secureStorage.setSessionActive(true);
      await _secureStorage.saveLastActivity(DateTime.now());

      print('✅ Usuario logueado y guardado (encriptado). ID: ${userData['id']}');
      return UserModel.fromJson(userData as Map<String, dynamic>).toEntity();
    } catch (e) {
      print('❌ Error en login: $e');
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    await StorageHelper.clearAll();
    await _secureStorage.clearAll();
    print('✅ Logout completo - Ambos almacenamientos limpiados');
  }

  @override
  Future<bool> isLoggedIn() async {
    final storageHelperLogged = await StorageHelper.isLoggedIn();
    final secureStorageLogged = await _secureStorage.isSessionActive();
    final hasToken = await _secureStorage.hasToken();

    return storageHelperLogged && secureStorageLogged && hasToken;
  }


  @override
  Future<String> getToken() async {
    final token = await _secureStorage.getToken();
    return token ?? '';
  }

  @override
  Future<Map<String, dynamic>> restoreSession() async {
    final userInfo = await _secureStorage.getUserInfo();
    final lastActivity = await _secureStorage.getLastActivity();
    final token = await _secureStorage.getToken();

    return {
      'user': userInfo,
      'lastActivity': lastActivity,
      'token': token,
    };
  }
}