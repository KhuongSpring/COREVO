class TrainingScheduleExerciseResponse {
  final int exerciseId;
  final String duration;

  TrainingScheduleExerciseResponse({
    required this.exerciseId,
    required this.duration,
  });

  factory TrainingScheduleExerciseResponse.fromJson(Map<String, dynamic> json) {
    return TrainingScheduleExerciseResponse(
      exerciseId: json['exerciseId'],
      duration: json['duration'],
    );
  }
}
