import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants/app_constants.dart';
import 'storage_helper.dart';

//singleton
class HttpHelper {
  static final HttpHelper _instance = HttpHelper._internal();
  factory HttpHelper() => _instance;
  HttpHelper._internal();

  //Token jwt
  String? _authToken;

  void setAuthToken(String token) {
    _authToken = token;
    StorageHelper.saveToken(token);
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = _authToken ?? await StorageHelper.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<dynamic> get(String endpoint) async {
    final url = '${AppConstants.baseUrl}$endpoint';
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('📤 GET a: $url');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    final response = await http.get(
      Uri.parse(url),
      headers: await _getHeaders(),
    );

    print('📥 Código: ${response.statusCode}');
    print('📥 Body: ${response.body}');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    return _handleResponse(response);
  }

  Future<dynamic> post(String endpoint, dynamic data) async {
        final url = '${AppConstants.baseUrl}$endpoint';
        print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('📤 POST a: $url');
    print('📦 Datos enviados: $data');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    final response = await http.post(
      Uri.parse(url),
      headers: await _getHeaders(),
      body: jsonEncode(data),
    );

    print('📥 Código respuesta: ${response.statusCode}');
    print('📥 Body respuesta: ${response.body}');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    return _handleResponse(response);
  }

  Future<dynamic> put(String endpoint, dynamic data) async {
    final url = '${AppConstants.baseUrl}$endpoint';
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('📤 PUT a: $url');
    print('📦 Datos enviados: $data');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    final response = await http.put(
      Uri.parse(url),
      headers: await _getHeaders(),
      body: jsonEncode(data),
    );

    print('📥 Código respuesta: ${response.statusCode}');
    print('📥 Body respuesta: ${response.body}');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    return _handleResponse(response);
  }

  Future<dynamic> delete(String endpoint) async {
    final url = '${AppConstants.baseUrl}$endpoint';
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('📤 DELETE a: $url');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    final response = await http.delete(
      Uri.parse(url),
      headers: await _getHeaders(),
    );

    print('📥 Código respuesta: ${response.statusCode}');
    print('📥 Body respuesta: ${response.body}');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    return _handleResponse(response);
  }

  dynamic _handleResponse(http.Response response) {
    print('📥 Código final: ${response.statusCode}');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return null;
      }
      try {
        return jsonDecode(response.body);
      } catch (e) {
        return response.body;
      }
    } else {
      String errorMessage = 'Error ${response.statusCode}';
      try {
        final errorData = jsonDecode(response.body);
        errorMessage = errorData['message'] ??
            errorData['error'] ??
            errorData['msg'] ??
            response.body;
      } catch (_) {
        errorMessage = response.body;
      }
      throw Exception(errorMessage);
    }
  }
}