import 'dart:convert';

import 'package:hit_tech/model/response/list_default_response.dart';
import 'package:hit_tech/model/response/training/training_exercise_preview_level_response.dart';
import 'package:hit_tech/model/response/training/training_exercise_preview_response.dart';
import 'package:hit_tech/model/response/training/training_plan_result_response.dart';
import 'package:hit_tech/service/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../core/constants/api_endpoint.dart';

class TrainingService {
  static Future<TrainingPlanResultResponse> getAllTrainingPlan(
    int pageNum,
    int pageSize,
  ) async {
    final token = await SharedPreferencesService.getAccessToken();

    final uri = Uri.parse(ApiEndpoint.getAllTrainingPlan).replace(
      queryParameters: {
        'page num': pageNum.toString(),
        'page size': pageSize.toString(),
      },
    );

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    final data = json.decode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      return TrainingPlanResultResponse.fromJson(data);
    } else {
      print('Error: $response.statusCode');
      throw Exception('Get profile failed');
    }
  }

  static Future<TrainingPlanResultResponse> getTrainingPlanByType(
    String type,
    int pageNum,
    int pageSize,
  ) async {
    final token = await SharedPreferencesService.getAccessToken();

    final uri = Uri.parse(ApiEndpoint.getTrainingPlanByType).replace(
      queryParameters: {
        'type': type,
        'page num': pageNum.toString(),
        'page size': pageSize.toString(),
      },
    );

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    final data = json.decode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      return TrainingPlanResultResponse.fromJson(data);
    } else {
      print('Error: $response.statusCode');
      throw Exception('Get profile failed');
    }
  }

  static Future<ListDefaultResponse> getTrainingExerciseByTargetMuscle(
    String targetMuscle,
    int pageNum,
    int pageSize,
  ) async {
    final token = await SharedPreferencesService.getAccessToken();

    final uri = Uri.parse(ApiEndpoint.getExerciseByPrimaryMuscle).replace(
      queryParameters: {
        'primary muscle': targetMuscle,
        'page num': pageNum.toString(),
        'page size': pageSize.toString(),
      },
    );

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    final data = json.decode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      return ListDefaultResponse<TrainingExercisePreviewLevelResponse>.fromJson(
        data,
        (json) => TrainingExercisePreviewLevelResponse.fromJson(json),
      );
    } else {
      print('Error: $response.statusCode');
      throw Exception('Get profile failed');
    }
  }
}
