import 'dart:convert';

class TrainingFlowRequest {
  final String? currentStep;
  final List<String> selectedValue;
  final Map<String, List<String>> selectedValues;

  TrainingFlowRequest({
    required this.currentStep,
    required this.selectedValue,
    required this.selectedValues,
  });

  Map<String, dynamic> toJson() {
    return {
      'currentStep': currentStep,
      'selectedValue': selectedValue,
      'selectedValues': selectedValues,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
