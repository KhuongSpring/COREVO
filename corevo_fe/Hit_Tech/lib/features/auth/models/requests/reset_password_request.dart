class ResetPasswordRequest {
  final String email;
  final String newPassword;
  final String reEnterPassword;

  ResetPasswordRequest({
    required this.email,
    required this.newPassword,
    required this.reEnterPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'newPassword': newPassword,
      'reEnterPassword': reEnterPassword,
    };
  }
}
