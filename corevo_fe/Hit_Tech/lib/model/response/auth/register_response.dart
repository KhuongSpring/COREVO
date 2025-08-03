class RegisterResponse {
  final String status;
  final String? data;

  RegisterResponse({required this.status, this.data});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      status: json['status'],
      data: json['data'],
    );
  }
}
