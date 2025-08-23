import 'dart:convert';

class TrainingDynamicSearchRequest {
  final String searchSentence;
  final List<int> levels;
  final List<int> locations;
  final List<int> equipments;
  final String goal;

  TrainingDynamicSearchRequest({
    required this.searchSentence,
    required this.levels,
    required this.locations,
    required this.equipments,
    required this.goal,
  });

  Map<String, dynamic> toJson() {
    return {
      'searchSentence': searchSentence,
      'levels': levels,
      'locations': locations,
      'equipments': equipments,
      'goal': goal,
    };
  }
}
