// import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:hit_tech/core/constants/api_endpoint.dart';
import 'package:hit_tech/features/health_infor/model/heath_infor_model.dart';

class HealthInforRepo {
  final Dio _dio;

  HealthInforRepo(this._dio);

  Future<bool> submitHealthInfo(HealthInfoModel healthInfo) async {
    try {
      final response = await _dio.post(
        ApiEndpoint.fillHeathInformation,
        data: healthInfo.toJson(),

        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          // Set a timeout for the request
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          // Add timeout settings
        ),
      );

      // Check for successful status codes (200-299)
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        // Optionally parse response for additional validation
        if (response.data != null) {
          final apiResponse = ApiResponse.fromJson(response.data);
          return apiResponse.success;
        }
        return true;
      } else {
        print('API returned status: ${response.statusCode}');
        return false;
      }
    } on DioException catch (e) {
      print('Dio error submitting health info: ${e.message}');
      print('Error type: ${e.type}');
      if (e.response != null) {
        print('Response data: ${e.response?.data}');
        print('Response status: ${e.response?.statusCode}');
      }
      return false;
    } catch (e) {
      print('Unexpected error submitting health info: $e');
      return false;
    }
  }
}

class ApiResponse {
  final bool success;
  final String message;

  ApiResponse({required this.success, this.message = ""});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? 'An error occurred',
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message};
  }
}
