import 'package:hit_tech/model/response/training/training_exercise_preview_response.dart';

class ListDefaultResponse<T> {
  final String status;
  final List<T> data;

  ListDefaultResponse({required this.status, required this.data});

  factory ListDefaultResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return ListDefaultResponse<T>(
      status: json['status'],
      data: (json['data'] as List<dynamic>)
          .map((item) => fromJsonT(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
