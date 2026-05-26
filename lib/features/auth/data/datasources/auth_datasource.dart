// lib/features/auth/data/datasources/auth_datasource.dart
import '../../../../core/helpers/http_helper.dart';
import '../../../../core/constants/app_constants.dart';

class AuthDatasource {
  final HttpHelper httpHelper = HttpHelper();

  Future<Map<String, dynamic>> register(String email, String password, String name) async {
    print('🔥 AuthDatasource.register llamado');
    print('📧 Email: $email');
    print('🔑 Password: $password');
    print('👤 Name: $name');

    final response = await httpHelper.post(AppConstants.registerEndpoint, {
      'email': email,
      'password': password,
      'name': name,
    });

    print('✅ Respuesta register: $response');
    return response;
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    print('🔥 AuthDatasource.login llamado');
    print('📧 Email: $email');
    print('🔑 Password: $password');

    final response = await httpHelper.post(AppConstants.loginEndpoint, {
      'email': email,
      'password': password,
    });

    print('✅ Respuesta login: $response');
    return response;
  }
}