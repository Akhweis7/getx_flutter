import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static const String _webBaseUrl = 'http://localhost:8080/Auth';
  static const String _mobileBaseUrl = 'https://185.140.181.252/kanban/api/Auth';

  static String get _baseUrl {
    const configuredBaseUrl = String.fromEnvironment('API_BASE_URL');
    if (configuredBaseUrl.isNotEmpty) {
      return configuredBaseUrl;
    }
    return kIsWeb ? _webBaseUrl : _mobileBaseUrl;
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'usernameoremail': username, 'password': password}),
    );
    return {'statusCode': response.statusCode, 'body': response.body};
  }

  Future<Map<String, dynamic>> signUp(
      String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/signup'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );
    return {'statusCode': response.statusCode, 'body': response.body};
  }

  Future<Map<String, dynamic>> googleSignUp(
      String idToken, String name, String email) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/google-signup'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'idToken': idToken, 'name': name, 'email': email}),
    );
    return {'statusCode': response.statusCode, 'body': response.body};
  }
}
