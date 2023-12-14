import 'dart:convert';
import 'package:http/http.dart' as http;

class CredentialsLogic {
  Future<String> requestCredentials(String email) async {
    var url = Uri.parse('https://app-ucsd.works/security/generate_credentials');
    var response = await http.post(
      url,
      body: {'email': email},
    );

    if (response.statusCode == 200) {
      var data = json.decode(utf8.decode(response.bodyBytes));
      return data['detail'] ?? 'Respuesta exitosa sin detalle';
    } else {
      var errorData = json.decode(utf8.decode(response.bodyBytes));
      String errorMessage = errorData['detail'] ?? 'Error desconocido';
      throw Exception('Error ${response.statusCode}: $errorMessage');
    }
  }
}
