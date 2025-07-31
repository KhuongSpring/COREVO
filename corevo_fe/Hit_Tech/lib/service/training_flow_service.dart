import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:hit_tech/service/shared_preferences.dart';
import 'package:hit_tech/utils/dio_client.dart';
import 'package:http/http.dart' as http;

import '../core/constants/api_endpoint.dart';
import '../model/request/training/training_flow_request.dart';
import '../model/response/training/training_flow_response.dart';

class TrainingFlowService {
  static Future<TrainingFlowResponse> sendStep(
    TrainingFlowRequest request,
  ) async {
    try {
      final response = await DioClient.dio
          .post(
            ApiEndpoint.flowStep,
            data: request.toJson(),
            options: Options(
              contentType: Headers.jsonContentType,
              sendTimeout: Duration(seconds: 5),
              receiveTimeout: Duration(seconds: 5)
            )
          );

      return TrainingFlowResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        print('Timeout: Không thể kết nối đến server.');
      } else {
        print('DIO EXCEPTION: ${e.message}');
        print('RESPONSE: ${e.response?.data}');
      }
      rethrow;
    } catch (e, stack) {
      print('EXCEPTION: $e');
      print('STACKTRACE: $stack');
      rethrow;
    }
  }
}
