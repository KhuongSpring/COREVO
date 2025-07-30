import 'package:hit_tech/core/constants/api_endpoint.dart';
import 'package:hit_tech/model/request/auth/forgot_password_request.dart';
import 'package:hit_tech/model/response/auth/forgot_password_response.dart';
import 'package:hit_tech/model/response/auth/login_response.dart';
import 'package:hit_tech/model/response/auth/reset_password_response.dart';
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
    final response = await http.post(
      Uri.parse(ApiEndpoint.login),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return LoginResponse.fromJson(data);
    } else {
      throw Exception('Login failed');
    }
  }

  static Future<RegisterResponse> register(RegisterRequest request) async {
    final response = await http.post(
      Uri.parse(ApiEndpoint.register),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    final data = json.decode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      return RegisterResponse.fromJson(data);
    } else {
      throw Exception('Registration failed');
    }
  }

  static Future<VerifyOtpResponse> verifyOtpToRegister(
    VerifyOtpRequest request,
  ) async {
    final response = await http.post(
      Uri.parse(ApiEndpoint.verifyOtp),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    final data = jsonDecode(response.body);
    return VerifyOtpResponse.fromJson(data);
  }

  static Future<ForgotPasswordResponse> sendEmailToForgotPassword(
    ForgotPasswordRequest request,
  ) async {
    final response = await http.post(
      Uri.parse(ApiEndpoint.sendEmailToForgotPassword),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    final data = jsonDecode(response.body);
    return ForgotPasswordResponse.fromJson(data);
  }

  static Future<VerifyOtpResponse> verifyOtpToResetPassword(
      VerifyOtpRequest request,
      ) async {
    final response = await http.post(
      Uri.parse(ApiEndpoint.verifyOptResetPassword),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    final data = jsonDecode(response.body);
    return VerifyOtpResponse.fromJson(data);
  }

  static Future<ResetPasswordResponse> resetPassword(
      ResetPasswordRequest request,
      ) async {
    final response = await http.post(
      Uri.parse(ApiEndpoint.resetPassword),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    final data = jsonDecode(response.body);
    return ResetPasswordResponse.fromJson(data);
  }
}
