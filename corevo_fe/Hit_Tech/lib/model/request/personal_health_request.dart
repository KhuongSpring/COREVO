class PersonalHealthRequest {
  final String gender;
  final int age;
  final int height;
  final double weight;
  final String activityLevel;

  PersonalHealthRequest({
    required this.gender,
    required this.age,
    required this.height,
    required this.weight,
    required this.activityLevel,
  });

  Map<String, dynamic> toJson() {
    return {
      'gender': gender,
      'age': age,
      'height': height,
      'weight': weight,
      'activityLevel': activityLevel,
    };
  }
}
