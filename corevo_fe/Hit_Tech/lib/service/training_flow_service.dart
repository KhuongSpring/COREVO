import 'dart:async';
import 'dart:convert';
import 'package:hit_tech/service/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../core/constants/api_endpoint.dart';
import '../model/request/training_flow_request.dart';
import '../model/response/training/training_flow_response.dart';

class TrainingFlowService {
  static const String url = ApiEndpoint.flowStep;

  static Future<TrainingFlowResponse> sendStep(
    TrainingFlowRequest request,
  ) async {
    try {
      final token = await SharedPreferencesService.getAccessToken();
      final response = await http
          .post(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: json.encode(request.toJson()),
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));
        return TrainingFlowResponse.fromJson(jsonData);
      } else {
        throw Exception('Lỗi khi gọi API: ${response.statusCode}');
      }
    } on TimeoutException catch (_) {
      print('Timeout: Không thể kết nối đến server.');
      rethrow;
    } catch (e, stack) {
      print('EXCEPTION: $e');
      print('STACKTRACE: $stack');
      rethrow;
    }
  }
}
