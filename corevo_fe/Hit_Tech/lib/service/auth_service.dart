import 'package:dio/dio.dart';
import 'package:hit_tech/core/constants/api_endpoint.dart';
import 'package:hit_tech/model/request/auth/forgot_password_request.dart';
import 'package:hit_tech/model/request/auth/oauth2_google_request.dart';
import 'package:hit_tech/model/response/auth/forgot_password_response.dart';
import 'package:hit_tech/model/response/auth/login_response.dart';
import 'package:hit_tech/model/response/auth/reset_password_response.dart';
import 'package:hit_tech/model/response/default_response.dart';
import 'package:hit_tech/service/shared_preferences.dart';
import 'package:hit_tech/utils/dio_client.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model/request/auth/login_request.dart';
import '../model/request/auth/register_request.dart';
import '../model/request/auth/reset_password_request.dart';
import '../model/request/auth/verify_otp_request.dart';
import '../model/response/auth/register_response.dart';
import '../model/response/auth/verify_opt_response.dart';

class AuthService {
  static Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await DioClient.dio.post(
        ApiEndpoint.login,
        data: request.toJson(),
        options: Options(
          contentType: Headers.jsonContentType,
          sendTimeout: Duration(seconds: 5),
          receiveTimeout: Duration(seconds: 5),
        ),
      );

      return LoginResponse.fromJson(response.data);
    } on DioException catch (e) {
      print('DIO ERROR: ${e.message}');
      print('RESPONSE: ${e.response?.data}');
      rethrow;
    } catch (e, stack) {
      print('ERROR: $e');
      print('STACKTRACE: $stack');
      rethrow;
    }
  }

  static Future<LoginResponse> loginWithGoogle(
    Oauth2GoogleRequest request,
  ) async {
    try {
      final response = await DioClient.dio.post(
        ApiEndpoint.loginWithGoogle,
        data: request.toJson(),
        options: Options(
          contentType: Headers.jsonContentType,
          sendTimeout: Duration(seconds: 5),
          receiveTimeout: Duration(seconds: 5),
        ),
      );

      return LoginResponse.fromJson(response.data);
    } on DioException catch (e) {
      print('DIO ERROR: ${e.message}');
      print('RESPONSE: ${e.response?.data}');
      rethrow;
    } catch (e, stack) {
      print('ERROR: $e');
      print('STACKTRACE: $stack');
      rethrow;
    }
  }

  static Future<RegisterResponse> register(RegisterRequest request) async {
    try {
      final response = await DioClient.dio.post(
        ApiEndpoint.register,
        data: request.toJson(),
        options: Options(
          contentType: Headers.jsonContentType,
          sendTimeout: Duration(seconds: 5),
          receiveTimeout: Duration(seconds: 5),
        ),
      );

      return RegisterResponse.fromJson(response.data);
    } on DioException catch (e) {
      print('DIO ERROR: ${e.message}');
      print('RESPONSE: ${e.response?.data}');
      rethrow;
    } catch (e, stack) {
      print('ERROR: $e');
      print('STACKTRACE: $stack');
      rethrow;
    }
  }

  static Future<VerifyOtpResponse> verifyOtpToRegister(
    VerifyOtpRequest request,
  ) async {
    try {
      final response = await DioClient.dio.post(
        ApiEndpoint.verifyOtp,
        data: request.toJson(),
        options: Options(
          contentType: Headers.jsonContentType,
          sendTimeout: Duration(seconds: 5),
          receiveTimeout: Duration(seconds: 5),
        ),
      );

      return VerifyOtpResponse.fromJson(response.data);
    } on DioException catch (e) {
      print('DIO ERROR: ${e.message}');
      print('RESPONSE: ${e.response?.data}');
      rethrow;
    } catch (e, stack) {
      print('ERROR: $e');
      print('STACKTRACE: $stack');
      rethrow;
    }
  }

  static Future<ForgotPasswordResponse> sendEmailToForgotPassword(
    ForgotPasswordRequest request,
  ) async {
    try {
      final response = await DioClient.dio.post(
        ApiEndpoint.sendEmailToForgotPassword,
        data: request.toJson(),
        options: Options(
          contentType: Headers.jsonContentType,
          sendTimeout: Duration(seconds: 5),
          receiveTimeout: Duration(seconds: 5),
        ),
      );

      return ForgotPasswordResponse.fromJson(response.data);
    } on DioException catch (e) {
      print('DIO ERROR: ${e.message}');
      print('RESPONSE: ${e.response?.data}');
      rethrow;
    } catch (e, stack) {
      print('ERROR: $e');
      print('STACKTRACE: $stack');
      rethrow;
    }
  }

  static Future<VerifyOtpResponse> verifyOtpToResetPassword(
    VerifyOtpRequest request,
  ) async {
    try {
      final response = await DioClient.dio.post(
        ApiEndpoint.verifyOptResetPassword,
        data: request.toJson(),
        options: Options(
          contentType: Headers.jsonContentType,
          sendTimeout: Duration(seconds: 5),
          receiveTimeout: Duration(seconds: 5),
        ),
      );

      return VerifyOtpResponse.fromJson(response.data);
    } on DioException catch (e) {
      print('DIO ERROR: ${e.message}');
      print('RESPONSE: ${e.response?.data}');
      rethrow;
    } catch (e, stack) {
      print('ERROR: $e');
      print('STACKTRACE: $stack');
      rethrow;
    }
  }

  static Future<ResetPasswordResponse> resetPassword(
    ResetPasswordRequest request,
  ) async {
    try {
      final response = await DioClient.dio.post(
        ApiEndpoint.resetPassword,
        data: request.toJson(),
        options: Options(
          contentType: Headers.jsonContentType,
          sendTimeout: Duration(seconds: 5),
          receiveTimeout: Duration(seconds: 5),
        ),
      );

      return ResetPasswordResponse.fromJson(response.data);
    } on DioException catch (e) {
      print('DIO ERROR: ${e.message}');
      print('RESPONSE: ${e.response?.data}');
      rethrow;
    } catch (e, stack) {
      print('ERROR: $e');
      print('STACKTRACE: $stack');
      rethrow;
    }
  }

  static Future<DefaultResponse> logout(String request) async {
    try {
      final response = await DioClient.dio.post(
        ApiEndpoint.logout,
        data: {'token': request},
        options: Options(
          contentType: Headers.jsonContentType,
          sendTimeout: Duration(seconds: 5),
          receiveTimeout: Duration(seconds: 5),
        ),
      );

      return DefaultResponse.fromJson(response.data);
    } on DioException catch (e) {
      print('DIO ERROR: ${e.message}');
      print('RESPONSE: ${e.response?.data}');
      rethrow;
    } catch (e, stack) {
      print('ERROR: $e');
      print('STACKTRACE: $stack');
      rethrow;
    }
  }

  static Future<String?> refreshAccessToken() async {
    final refreshToken = await SharedPreferencesService.getRefreshToken();
    if (refreshToken == null) return null;

    final response = await http.post(
      Uri.parse(ApiEndpoint.refreshToken),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refreshToken': refreshToken}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final newAccessToken = data['data']['accessToken'];
      if (newAccessToken != null) {
        await SharedPreferencesService.saveAccessToken(newAccessToken);
        return newAccessToken;
      } else {
        await SharedPreferencesService.clearAll();
        return null;
      }
    } else {
      await SharedPreferencesService.clearAll();
      return null;
    }
  }

  static Future<DefaultResponse> getPrivacy() async {
    try {
      final response = await DioClient.dio.get(
        ApiEndpoint.getPolicyPrivacy,
        options: Options(
          contentType: Headers.jsonContentType,
          sendTimeout: Duration(seconds: 5),
          receiveTimeout: Duration(seconds: 5),
        ),
      );

      return DefaultResponse.fromJson(response.data);
    } on DioException catch (e) {
      print('DIO ERROR: ${e.message}');
      print('RESPONSE: ${e.response?.data}');
      rethrow;
    } catch (e, stack) {
      print('ERROR: $e');
      print('STACKTRACE: $stack');
      rethrow;
    }
  }

  static Future<DefaultResponse> getTerms() async {
    try {
      final response = await DioClient.dio.get(
        ApiEndpoint.getPolicyTerms,
        options: Options(
          contentType: Headers.jsonContentType,
          sendTimeout: Duration(seconds: 5),
          receiveTimeout: Duration(seconds: 5),
        ),
      );

      return DefaultResponse.fromJson(response.data);
    } on DioException catch (e) {
      print('DIO ERROR: ${e.message}');
      print('RESPONSE: ${e.response?.data}');
      rethrow;
    } catch (e, stack) {
      print('ERROR: $e');
      print('STACKTRACE: $stack');
      rethrow;
    }
  }

  static Future<DefaultResponse> sendEmailToRecoveryAccount(
      String email,
      ) async {
    try {
      final response = await DioClient.dio.post(
        ApiEndpoint.accountRecover,
        data: {
          "email": email
        },
        options: Options(
          contentType: Headers.jsonContentType,
          sendTimeout: Duration(seconds: 5),
          receiveTimeout: Duration(seconds: 5),
        ),
      );

      return DefaultResponse.fromJson(response.data);
    } on DioException catch (e) {
      print('DIO ERROR: ${e.message}');
      print('RESPONSE: ${e.response?.data}');
      rethrow;
    } catch (e, stack) {
      print('ERROR: $e');
      print('STACKTRACE: $stack');
      rethrow;
    }
  }

  static Future<VerifyOtpResponse> verifyOtpToRecover(
      VerifyOtpRequest request,
      ) async {
    try {
      final response = await DioClient.dio.post(
        ApiEndpoint.recoverAccount,
        data: request.toJson(),
        options: Options(
          contentType: Headers.jsonContentType,
          sendTimeout: Duration(seconds: 5),
          receiveTimeout: Duration(seconds: 5),
        ),
      );

      return VerifyOtpResponse.fromJson(response.data);
    } on DioException catch (e) {
      print('DIO ERROR: ${e.message}');
      print('RESPONSE: ${e.response?.data}');
      rethrow;
    } catch (e, stack) {
      print('ERROR: $e');
      print('STACKTRACE: $stack');
      rethrow;
    }
  }

}
