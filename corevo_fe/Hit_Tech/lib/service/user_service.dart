import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hit_tech/model/response/default_response.dart';
import 'package:hit_tech/model/response/user/user_profile_response.dart';
import 'package:hit_tech/utils/dio_client.dart';
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';

import '../core/constants/api_endpoint.dart';
import '../model/request/personal_health_request.dart';

class UserService {
  static Future<DefaultResponse> fillPersonalHealth(
    PersonalHealthRequest request,
  ) async {
    try {
      final response = await DioClient.dio.post(
        ApiEndpoint.fillHeathInformation,
        data: request.toJson(),
        options: Options(
          contentType: Headers.jsonContentType,
          sendTimeout: Duration(seconds: 5),
          receiveTimeout: Duration(seconds: 5),
        ),
      );
      return DefaultResponse.fromJson(response.data);
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

  static Future<DefaultResponse> updatePersonalInformation(
      Map<String, dynamic> request,
      ) async {
    try {
      final response = await DioClient.dio.put(
        ApiEndpoint.updateProfile,
        data: request,
        options: Options(
          contentType: Headers.jsonContentType,
          sendTimeout: Duration(seconds: 5),
          receiveTimeout: Duration(seconds: 5),
        ),
      );
      return DefaultResponse.fromJson(response.data);
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


  static Future<UserProfileResponse> getProfile() async {
    try {
      final response = await DioClient.dio.get(
        ApiEndpoint.getProfile,
        options: Options(
          contentType: Headers.jsonContentType,
          sendTimeout: Duration(seconds: 5),
          receiveTimeout: Duration(seconds: 5),
        ),
      );

      return UserProfileResponse.fromJson(response.data);
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

  static Future<UserProfileResponse?> uploadAvatar(File imageFile) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          imageFile.path,
          filename: path.basename(imageFile.path),
          contentType: MediaType('image', 'jpeg'),
        ),
      });

      final response = await DioClient.dio.post(
        ApiEndpoint.uploadAvatar,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

      return UserProfileResponse.fromJson(response.data);
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
