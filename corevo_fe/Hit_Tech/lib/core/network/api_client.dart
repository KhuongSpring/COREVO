import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiClient {
  static const String baseUrl = 'http://192.168.184.103:8080/api/v1';

  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': '*/*',
  };

  static Future<Map<String, dynamic>> post(
      String endpoint,
      Map<String, dynamic> data,
      ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: defaultHeaders,
        body: jsonEncode(data),
      );

      return {
        'statusCode': response.statusCode,
        'data': response.body.isNotEmpty ? jsonDecode(response.body) : null,
      };
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  static Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: defaultHeaders,
      );

      return {
        'statusCode': response.statusCode,
        'data': response.body.isNotEmpty ? jsonDecode(response.body) : null,
      };
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}