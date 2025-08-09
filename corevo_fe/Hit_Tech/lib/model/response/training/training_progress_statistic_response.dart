class TrainingProgressStatisticResponse {
  final String month;
  final int year;
  final List<bool> currentMonthCompletions;
  final int currentStreak;
  final int longestStreak;

  TrainingProgressStatisticResponse({
    required this.month,
    required this.year,
    required this.currentMonthCompletions,
    required this.currentStreak,
    required this.longestStreak,
  });

  factory TrainingProgressStatisticResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return TrainingProgressStatisticResponse(
      month: json['month'] ?? '',
      year: json['year'] ?? '',
      currentMonthCompletions: List<bool>.from(
        json['currentMonthCompletions'] ?? [],
      ),
      currentStreak: json['currentStreak'] ?? '',
      longestStreak: json['longestStreak'] ?? '',
    );
  }
}
