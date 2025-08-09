import 'package:hit_tech/model/response/training/training_schedule_exercise_response.dart';

class TrainingScheduleExerciseGroupResponse {
  final String? note;
  final List<TrainingScheduleExerciseResponse> exercises;

  TrainingScheduleExerciseGroupResponse({
    required this.note,
    required this.exercises,
  });

  factory TrainingScheduleExerciseGroupResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return TrainingScheduleExerciseGroupResponse(
      note: json['note'],
      exercises: (json['exercises'] as List)
          .map((e) => TrainingScheduleExerciseResponse.fromJson(e))
          .toList(),
    );
  }
}
