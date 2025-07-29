class LoginResponse {
  final String status;
  final String? message;
  String? accessToken;
  String? refreshToken;
  String? userId;
  bool? isDeleted;
  bool? canRecovery;
  int? dayRecoveryRemaining;

  LoginResponse({
    required this.status,
    required this.message,
    this.accessToken,
    this.refreshToken,
    this.userId,
    this.isDeleted,
    this.canRecovery,
    this.dayRecoveryRemaining,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['data']['status'],
      message: json['data']['message'],
      accessToken: json['data']?['accessToken'],
      refreshToken: json['data']?['refreshToken'],
      userId: json['data']?['id'],
      isDeleted: json['data']?['isDeleted'],
      canRecovery: json['data']?['canRecovery'],
      dayRecoveryRemaining: json['data']?['dayRecoveryRemaining'],
    );
  }
}
