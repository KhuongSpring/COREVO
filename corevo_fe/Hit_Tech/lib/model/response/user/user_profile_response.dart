class UserProfileResponse {
  final String status;
  String? id;
  String? username;
  String? email;
  String? firstName;
  String? lastName;
  String? birth;
  String? phone;
  String? nationality;
  String? linkAvatar;
  Object? userHealth;

  UserProfileResponse({
    required this.status,
    this.id,
    this.username,
    this.email,
    this.firstName,
    this.lastName,
    this.birth,
    this.phone,
    this.nationality,
    this.linkAvatar,
    this.userHealth,
  });

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
    return UserProfileResponse(
      status: json['status'],
      id: json['data']['id'],
      username: json['data']['username'],
      email: json['data']['email'],
      firstName: json['data']['firstName'],
      lastName: json['data']['lastName'],
      birth: json['data']['birth'],
      phone: json['data']['phone'],
      nationality: json['data']['nationality'],
      linkAvatar: json['data']['linkAvatar'],
      userHealth: json['data']['userHealth'],
    );
  }
}
