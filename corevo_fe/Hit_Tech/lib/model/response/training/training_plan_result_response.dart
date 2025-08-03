import 'package:hit_tech/model/response/training/training_plan_response.dart';

class TrainingPlanResultResponse {
  final String status;
  final List<TrainingPlanResponse> items;

  TrainingPlanResultResponse({required this.status, required this.items});

  factory TrainingPlanResultResponse.fromJson(Map<String, dynamic> json) {
    return TrainingPlanResultResponse(
      status: json['status'],
      items: (json['data']['items'] as List)
          .map((item) => TrainingPlanResponse.fromJson(item))
          .toList(),
    );
  }
}
