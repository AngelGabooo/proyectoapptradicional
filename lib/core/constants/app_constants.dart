// lib/core/constants/app_constants.dart
class AppConstants {
  // ✅ URL correcta de Render
  static const String baseUrl = 'https://taskflow-api-y0m3.onrender.com/api';

  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String tasksEndpoint = '/tasks';

  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
}