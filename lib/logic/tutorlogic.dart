import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TutorRequestLogic {
  final String studentInfoUrl = 'https://app-ucsd.works/accounts/student';
  final String dueClassesUrl =
      'https://app-ucsd.works/catalog/subject_student/?status=due';
  final String periodsUrl = 'https://app-ucsd.works/general/academic_period/';
  final String tutorRequestUrl =
      'https://app-ucsd.works/orders/generate_request_tutoring/';
  final _storage = FlutterSecureStorage();

  Future<Map<String, dynamic>> fetchStudentInfo() async {
    try {
      String? token = await _storage.read(key: 'access_token');
      if (token == null) {
        print('No access token found');
        return {};
      }
      final response = await http.get(
        Uri.parse(studentInfoUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> responseData = json.decode(response.body);
        if (responseData.isNotEmpty) {
          return responseData[0];
        } else {
          return {};
        }
      } else {
        print('Failed to load student info: ${response.statusCode}');
        return {};
      }
    } catch (e) {
      print('Exception caught: $e');
      return {};
    }
  }

  Future<List<dynamic>> fetchDueClasses() async {
    return _fetchClasses(dueClassesUrl);
  }

  Future<List<dynamic>> fetchPeriods() async {
    return _fetchClasses(periodsUrl);
  }

  Future<List<dynamic>> _fetchClasses(String url) async {
    try {
      String? token = await _storage.read(key: 'access_token');
      if (token == null) {
        print('No access token found');
        return [];
      }
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        String utf8Response = utf8.decode(response.bodyBytes);
        return json.decode(utf8Response);
      } else {
        print('Failed to load data from $url: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Exception caught: $e');
      return [];
    }
  }

  Future<String> sendTutorRequest(String subjectId, String periodId) async {
    try {
      String? token = await _storage.read(key: 'access_token');
      if (token == null) {
        return 'No access token found';
      }
      final response = await http.post(
        Uri.parse(tutorRequestUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'subject_id': subjectId,
          'period_id': periodId,
        }),
      );
      if (response.statusCode == 200) {
        return 'Solicitud de tutoría enviada con éxito.';
      } else {
        var responseData = json.decode(response.body);
        String errorMessage = responseData['detail'] ?? 'Error desconocido';
        return 'Error al enviar la solicitud de tutoría: $errorMessage';
      }
    } catch (e) {
      return 'Error al enviar la solicitud: $e';
    }
  }
}
