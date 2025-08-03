import 'package:hit_tech/model/response/training/training_plan_response.dart';

class TrainingFlowResponse {
  final String? nextStep;
  final Map<String, List<String>> selectedValues;
  final List<TrainingPlanResponse>? trainingPlans;
  final List<String> options;
  final bool finalStep;

  TrainingFlowResponse({
    required this.nextStep,
    required this.selectedValues,
    required this.options,
    required this.finalStep,
    required this.trainingPlans,
  });

  factory TrainingFlowResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    return TrainingFlowResponse(
      nextStep: data['nextStep'],
      selectedValues: Map<String, List<String>>.from(
        (data['selectedValues'] as Map).map(
          (key, value) => MapEntry(key as String, List<String>.from(value)),
        ),
      ),
      trainingPlans: (data['trainingPlans'] as List<dynamic>? ?? [])
          .map((e) => TrainingPlanResponse.fromJson(e))
          .toList(),
      finalStep: data['finalStep'] ?? false,
      options: _normalizeOptions(data['options']),
    );
  }

  static List<String> _normalizeOptions(dynamic rawOptions) {
    if (rawOptions is List) {
      return rawOptions
          .expand((group) {
            if (group is List) {
              return group.map((item) {
                if (item is String) return item;
                if (item is Map<String, dynamic> && item.isNotEmpty) {
                  return item.values.first.toString();
                }
                return item.toString();
              });
            } else if (group is String) {
              return [group];
            }
            return <String>[];
          })
          .toSet()
          .cast<String>()
          .toList();
    }
    return <String>[];
  }

  @override
  String toString() {
    return '''
TrainingFlowResponse(
  nextStep: $nextStep,
  selectedValues: $selectedValues,
  trainingPlans: $trainingPlans,
  options: $options,
  finalStep: $finalStep
)
''';
  }
}
