import 'package:hit_tech/core/constants/app_message.dart';

class VerifyOtpResponse {
  final bool status;
  final String? message;

  VerifyOtpResponse({required this.status, this.message});

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponse(
      status: json['status'] == 'SUCCESS' ? true : false,
      message: json['status'] == 'SUCCESS'
          ? AuthMessage.sucVerifyOtp
          : AuthMessage.errOtpInvalid,
    );
  }
}
