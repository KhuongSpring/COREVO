class ExerciseSetProgress {
  final int exerciseId;
  final int totalSets;
  List<bool> setCompleted;

  ExerciseSetProgress({required this.exerciseId, required this.totalSets})
      : setCompleted = List.filled(totalSets, false);
}
