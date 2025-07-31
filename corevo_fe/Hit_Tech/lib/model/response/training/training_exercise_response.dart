class TrainingExerciseResponse {
  final String name;
  final List<int> levelIds;
  final List<int> typeIds;
  final List<int> primaryMuscleIds;
  final List<int> secondaryMuscleIds;
  final List<int> equipmentIds;
  final List<int> locationIds;
  final int? minSet;
  final int? maxSet;
  final int? minRep;
  final int? maxRep;
  final int? minDuration;
  final int? maxDuration;
  final List<int> goalIds;
  final String imageURL;
  final String description;

  TrainingExerciseResponse({
    required this.name,
    required this.levelIds,
    required this.typeIds,
    required this.primaryMuscleIds,
    required this.secondaryMuscleIds,
    required this.equipmentIds,
    required this.locationIds,
    this.minSet,
    this.maxSet,
    this.minRep,
    this.maxRep,
    this.minDuration,
    this.maxDuration,
    required this.goalIds,
    required this.imageURL,
    required this.description,
  });

  factory TrainingExerciseResponse.fromJson(Map<String, dynamic> json) {
    return TrainingExerciseResponse(
      name: json['name'],
      levelIds: List<int>.from(json['levelIds'] ?? []),
      typeIds: List<int>.from(json['typeIds'] ?? []),
      primaryMuscleIds: List<int>.from(json['primaryMuscleIds'] ?? []),
      secondaryMuscleIds: List<int>.from(json['secondaryMuscleIds'] ?? []),
      equipmentIds: List<int>.from(json['equipmentIds'] ?? []),
      locationIds: List<int>.from(json['locationIds'] ?? []),
      minSet: json['minSet'],
      maxSet: json['maxSet'],
      minRep: json['minRep'],
      maxRep: json['maxRep'],
      minDuration: json['minDuration'],
      maxDuration: json['maxDuration'],
      goalIds: List<int>.from(json['goalIds'] ?? []),
      imageURL: json['imageURL'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
