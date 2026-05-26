// lib/features/auth/data/repositories/auth_repository_impl.dart
import 'dart:convert';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_datasource.dart';
import '../models/user_model.dart';
import '../../../../core/helpers/storage_helper.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource datasource;

  AuthRepositoryImpl(this.datasource);

  @override
  Future<User> register(String email, String password, String name) async {
    try {
      final data = await datasource.register(email, password, name);
      print('🔍 Respuesta REGISTER: $data');

      final userData = data['user'];

      if (userData == null) {
        throw Exception('No se recibieron datos del usuario');
      }

      // Como no hay token, solo guardamos el usuario
      await StorageHelper.saveUser(jsonEncode(userData));
      // No guardamos token porque el backend no lo genera

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

      if (userData == null) {
        throw Exception('No se recibieron datos del usuario');
      }

      await StorageHelper.saveUser(jsonEncode(userData));

      return UserModel.fromJson(userData as Map<String, dynamic>).toEntity();
    } catch (e) {
      print('❌ Error en login: $e');
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    await StorageHelper.clearAll();
  }

  @override
  Future<bool> isLoggedIn() async {
    return await StorageHelper.isLoggedIn(); // Cambiaremos esto después
  }
}