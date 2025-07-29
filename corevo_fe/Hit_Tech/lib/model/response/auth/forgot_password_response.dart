class ForgotPasswordResponse {
  final String status;
  final String? data;

  ForgotPasswordResponse({required this.status, this.data});

  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordResponse(
      status: json['status'],
      data: json['data'],
    );
  }
}
