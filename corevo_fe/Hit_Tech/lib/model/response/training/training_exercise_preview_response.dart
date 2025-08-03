class TrainingExercisePreviewResponse {
  final int id;
  final String name;
  final String imageURL;
  final String description;
  final String levelName;

  TrainingExercisePreviewResponse({
    required this.id,
    required this.name,
    required this.imageURL,
    required this.description,
    required this.levelName,
  });

  factory TrainingExercisePreviewResponse.fromJson(Map<String, dynamic> json) {
    return TrainingExercisePreviewResponse(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      imageURL: json['imageURL'] ?? '',
      description: json['description'] ?? '',
      levelName: json['levelName'] ?? '',
    );
  }
}
