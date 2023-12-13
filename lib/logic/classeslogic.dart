import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ClassesLogic {
  final String apiUrl = 'https://app-ucsd.works/catalog/class';
  final _storage = FlutterSecureStorage();

  Future<List<dynamic>> fetchCurrentClasses() async {
    try {
      String? token = await _storage.read(key: 'access_token');

      if (token == null) {
        print('No access token found');
        return [];
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
        return json.decode(utf8Response);
      } else {
        print('Failed to load classes: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Exception caught: $e');
      return [];
    }
  }

  Future<List<dynamic>> fetchDueClasses() async {
    try {
      String? token = await _storage.read(key: 'access_token');

      if (token == null) {
        print('No access token found');
        return [];
      }

      final response = await http.get(
        Uri.parse('https://app-ucsd.works/catalog/subject_student/?status=due'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        String utf8Response = utf8.decode(response.bodyBytes);
        return json.decode(utf8Response);
      } else {
        print('Failed to load due classes: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Exception caught: $e');
      return [];
    }
  }

  Future<List<dynamic>> fetchApprovedClasses() async {
    try {
      String? token = await _storage.read(key: 'access_token');

      if (token == null) {
        print('No access token found');
        return [];
      }

      final response = await http.get(
        Uri.parse(
            'https://app-ucsd.works/catalog/subject_student/?status=approved'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        String utf8Response = utf8.decode(response.bodyBytes);
        return json.decode(utf8Response);
      } else {
        print('Failed to load due classes: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Exception caught: $e');
      return [];
    }
  }

  Future<List<dynamic>> fetchRequestedTutorings() async {
    return _fetchTutoringsByStatus('pending');
  }

  Future<List<dynamic>> fetchAcceptedTutorings() async {
    return _fetchTutoringsByStatus('accepted');
  }

  Future<List<dynamic>> fetchDeclinedTutorings() async {
    return _fetchTutoringsByStatus('denied');
  }

  Future<List<dynamic>> _fetchTutoringsByStatus(String status) async {
    String apiUrl =
        'https://app-ucsd.works/orders/request_tutoring?status=$status';
    try {
      String? token = await _storage.read(key: 'access_token');

      if (token == null) {
        print('No access token found');
        return [];
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
        return json.decode(utf8Response);
      } else {
        print('Failed to load classes: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Exception caught: $e');
      return [];
    }
  }
}
