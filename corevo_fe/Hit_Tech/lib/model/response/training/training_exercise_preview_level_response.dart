import 'package:hit_tech/model/response/training/training_exercise_preview_response.dart';

class TrainingExercisePreviewLevelResponse {
  final String levelName;
  final List<TrainingExercisePreviewResponse> exercises;

  TrainingExercisePreviewLevelResponse({
    required this.levelName,
    required this.exercises,
  });

  factory TrainingExercisePreviewLevelResponse.fromJson(Map<String, dynamic> json) {
    return TrainingExercisePreviewLevelResponse(
      levelName: json['levelName'],
      exercises: (json['exercises'] as List)
          .map((e) => TrainingExercisePreviewResponse.fromJson(e))
          .toList(),
    );
  }
}
