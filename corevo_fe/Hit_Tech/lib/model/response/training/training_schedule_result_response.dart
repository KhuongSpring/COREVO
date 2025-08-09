import 'package:hit_tech/model/response/training/training_schedule_response.dart';

class TrainingScheduleResultResponse {
  final String status;
  final List<TrainingScheduleResponse> days;

  TrainingScheduleResultResponse({required this.status, required this.days});

  factory TrainingScheduleResultResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> daysJson = json['data']['days'];
    return TrainingScheduleResultResponse(
      status: json['status'],
      days: daysJson.map((e) => TrainingScheduleResponse.fromJson(e)).toList(),
    );
  }
}
