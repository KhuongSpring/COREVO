class ResetPasswordResponse {
  final String status;

  ResetPasswordResponse({required this.status});

  factory ResetPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ResetPasswordResponse(
      status: json['status'],
    );
  }
}
