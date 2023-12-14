import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginLogic {
  final _storage = FlutterSecureStorage();

  Future<Map<String, dynamic>?> login(
      String emailOrUser, String password) async {
    final bool isValidEmail = RegExp(r'^.+@.+\..+$').hasMatch(emailOrUser);

    final bool isValidUserFormat =
        RegExp(r'^\d{4}-\d{4}$').hasMatch(emailOrUser);

    if (!(isValidEmail || isValidUserFormat) || password.length < 8) {
      return Future.value(
          {"error": "Formato de usuario o contraseña inválido"});
    }

    final response = await http.post(
      Uri.parse('https://app-ucsd.works/auth/login/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': emailOrUser,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      await _storage.write(key: 'access_token', value: responseData['access']);
      await _storage.write(
          key: 'user', value: json.encode(responseData['user']));
      return responseData;
    } else {
      final Map<String, dynamic> responseData = json.decode(response.body);
      return {"error": responseData['error'] ?? 'Error desconocido'};
    }
  }
}
