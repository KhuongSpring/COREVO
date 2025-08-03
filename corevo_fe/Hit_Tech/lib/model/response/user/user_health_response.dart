class UserHealthResponse {
  String? gender;
  int? height;
  int? weight;
  int? age;
  String? activityLevel;
  double? basalMetabolicRate;
  int? maximumHeartRate;
  double? tdee;

  UserHealthResponse({
    this.gender,
    this.height,
    this.weight,
    this.age,
    this.activityLevel,
    this.basalMetabolicRate,
    this.maximumHeartRate,
    this.tdee,
  });

  factory UserHealthResponse.fromJson(Map<String, dynamic> json) {
    return UserHealthResponse(
      gender: json['gender'],
      height: json['height'],
      weight: json['weight'],
      age: json['age'],
      activityLevel: json['activityLevel'],
      basalMetabolicRate: json['basalMetabolicRate'],
      maximumHeartRate: json['maximumHeartRate'],
      tdee: json['tdee'],
    );
  }
}
