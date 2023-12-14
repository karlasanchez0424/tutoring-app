import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomePageLogic {
  final String apiUrl = 'https://app-ucsd.works/accounts/student/';
  final _storage = FlutterSecureStorage();

  Future<Map<String, dynamic>?> fetchStudentInfo() async {
    try {
      String? token = await _storage.read(key: 'access_token');

      if (token == null) {
        print('No access token found');
        return null;
      }

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        String utf8Response = utf8.decode(response.bodyBytes);
        List<dynamic> data = json.decode(utf8Response);
        return data.isNotEmpty ? data[0] : null;
      } else {
        print('Failed to load student info: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception caught: $e');
      return null;
    }
  }
}
