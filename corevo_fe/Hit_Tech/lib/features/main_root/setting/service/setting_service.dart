import 'dart:io';
import 'package:dio/dio.dart';
import '../model/user_profile_model.dart';
import '../model/setting_request_model.dart';

class SettingService {
  final Dio _dio;

  SettingService({Dio? dio}) : _dio = dio ?? Dio() {
    _setupDio();
  }

  void _setupDio() {
    _dio.options = BaseOptions(
      baseUrl: 'http://localhost:8080',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    // Add interceptor for logging
    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true, error: true),
    );
  }

  /// GET /api/v1/user/profile - Lấy thông tin profile user
  Future<UserProfileModel> getUserProfile() async {
    try {
      final response = await _dio.get('/api/v1/user/profile');

      if (response.statusCode == 200) {
        // Assuming the response structure based on API docs
        return UserProfileModel.fromJson(response.data);
      } else {
        throw Exception('Failed to get user profile: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<ApiResponse<UserProfileModel>> updateProfile({
    required UpdateProfileRequest request,
  }) async {
    try {
      final response = await _dio.put(
        '/api/v1/user/update-profile',
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        return ApiResponse.fromJson(
          response.data,
          (data) => UserProfileModel.fromJson(data),
        );
      } else {
        throw Exception('Failed to update profile: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// POST /api/v1/user/upload-avatar - Tải lên ảnh đại diện
  Future<ApiResponse<String>> uploadAvatar({required File avatarFile}) async {
    try {
      // Create FormData for file upload
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          avatarFile.path,
          filename: avatarFile.path.split('/').last,
        ),
      });

      final response = await _dio.post(
        '/api/v1/user/upload-avatar',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      if (response.statusCode == 200) {
        return ApiResponse.fromJson(response.data, (data) => data.toString());
      } else {
        throw Exception('Failed to upload avatar: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// POST /api/v1/user/personal-information - Điền thông tin cá nhân
  Future<ApiResponse<String>> updatePersonalInformation({
    required PersonalInformationRequest request,
  }) async {
    try {
      final response = await _dio.post(
        '/api/v1/user/personal-information',
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        return ApiResponse.fromJson(response.data, (data) => data.toString());
      } else {
        throw Exception(
          'Failed to update personal information: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// DELETE /api/v1/user/delete-my-account - Xóa tài khoản
  Future<ApiResponse<String>> deleteMyAccount() async {
    try {
      final response = await _dio.delete('/api/v1/user/delete-my-account');

      if (response.statusCode == 200) {
        return ApiResponse.fromJson(response.data, (data) => data.toString());
      } else {
        throw Exception('Failed to delete account: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// Helper method to handle Dio errors
  Exception _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return Exception('Connection timeout');
      case DioExceptionType.sendTimeout:
        return Exception('Send timeout');
      case DioExceptionType.receiveTimeout:
        return Exception('Receive timeout');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['message'] ?? 'Unknown error';
        return Exception('Server error ($statusCode): $message');
      case DioExceptionType.cancel:
        return Exception('Request cancelled');
      case DioExceptionType.connectionError:
        return Exception('Connection error');
      default:
        return Exception('Network error: ${e.message}');
    }
  }
}
