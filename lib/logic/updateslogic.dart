import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UpdatesLogic {
  final String apiUrl = 'https://app-ucsd.works/security/notification/';
  final _storage = FlutterSecureStorage();

  Future<List<dynamic>?> fetchUpdates() async {
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
        return data;
      } else {
        print('Failed to load updates: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception caught: $e');
      return null;
    }
  }

  Future<List<dynamic>?> fetchComments() async {
    String? token = await _storage.read(key: 'access_token');

    if (token == null) {
      print('No access token found');
      return null;
    }

    final response = await http.get(
      Uri.parse('https://app-ucsd.works/orders/request_tutoring'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      String utf8Response = utf8.decode(response.bodyBytes);
      List<dynamic> data = json.decode(utf8Response);
      return data;
    } else {
      print('Failed to load comments: ${response.statusCode}');
      return null;
    }
  }
}
