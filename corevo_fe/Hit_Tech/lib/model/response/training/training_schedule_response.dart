import 'package:hit_tech/model/response/training/training_schedule_exercise_group_response.dart';

class TrainingScheduleResponse {
  final String dayOfWeek;
  final String name;
  final String? duration;
  final String? location;
  final String description;
  final TrainingScheduleExerciseGroupResponse? exerciseGroups;

  TrainingScheduleResponse({
    required this.dayOfWeek,
    required this.name,
    required this.duration,
    required this.location,
    required this.description,
    required this.exerciseGroups,
  });

  factory TrainingScheduleResponse.fromJson(Map<String, dynamic> json) {
    return TrainingScheduleResponse(
      dayOfWeek: json['dayOfWeek'],
      name: json['name'],
      duration: json['duration'],
      location: json['location'],
      description: json['description'],
      exerciseGroups: TrainingScheduleExerciseGroupResponse.fromJson(
        json['exerciseGroups'],
      ),
    );
  }
}
