class TrainingPlan {
  final String name;
  final String description;
  final String aim;
  final String goals;
  final String type;
  final String duration;
  final String frequency;
  final List<int> levelIds;
  final List<int> locationIds;
  final List<int> equipmentIds;

  TrainingPlan({
    required this.name,
    required this.description,
    required this.aim,
    required this.goals,
    required this.type,
    required this.duration,
    required this.frequency,
    required this.levelIds,
    required this.locationIds,
    required this.equipmentIds,
  });

  factory TrainingPlan.fromJson(Map<String, dynamic> json) {
    return TrainingPlan(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      aim: json['aim'] ?? '',
      goals: json['goals'] ?? '',
      type: json['type'] ?? '',
      duration: json['duration'] ?? '',
      frequency: json['frequency'] ?? '',
      levelIds: List<int>.from(json['levelIds'] ?? []),
      locationIds: List<int>.from(json['locationIds'] ?? []),
      equipmentIds: List<int>.from(json['equipmentIds'] ?? []),
    );
  }

  @override
  String toString() {
    return '''
TrainingPlan(
  name: $name,
  description: $description,
  aim: $aim,
  goals: $goals,
  type: $type,
  duration: $duration,
  frequency: $frequency,
  levelIds: $levelIds,
  locationIds: $locationIds,
  equipmentIds: $equipmentIds
)''';
  }
}
