class HealthInfoModel {
  final String gender;
  final int height;
  final double weight;
  final int age;
  final String activityLevel;

  HealthInfoModel({
    required this.gender,
    required this.height,
    required this.weight,
    required this.age,
    required this.activityLevel,
  });

  Map<String, dynamic> toJson() {
    return {
      'gender': gender,
      'height': height,
      'weight': weight,
      'age': age,
      'activityLevel': activityLevel,
    };
  }

  factory HealthInfoModel.fromJson(Map<String, dynamic> json) {
    return HealthInfoModel(
      gender: json['gender'],
      height: json['height'],
      weight: json['weight'].toDouble(),
      age: json['age'],
      activityLevel: json['activityLevel'],
    );
  }
}
