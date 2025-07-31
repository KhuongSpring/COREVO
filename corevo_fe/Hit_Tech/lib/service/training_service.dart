import 'package:dio/dio.dart';
import 'package:hit_tech/model/response/list_default_response.dart';
import 'package:hit_tech/model/response/training/training_exercise_preview_level_response.dart';
import 'package:hit_tech/model/response/training/training_plan_result_response.dart';
import 'package:hit_tech/utils/dio_client.dart';

import '../core/constants/api_endpoint.dart';

class TrainingService {
  static Future<TrainingPlanResultResponse> getAllTrainingPlan(
    int pageNum,
    int pageSize,
  ) async {
    try {
      final response = await DioClient.dio.get(
        ApiEndpoint.getAllTrainingPlan,
        queryParameters: {
          'page num': pageNum.toString(),
          'page size': pageSize.toString(),
        },
        options: Options(
          contentType: Headers.jsonContentType,
          sendTimeout: Duration(seconds: 5),
          receiveTimeout: Duration(seconds: 5),
        ),
      );

      return TrainingPlanResultResponse.fromJson(response.data);
    } on DioException catch (e) {
      print('DIO ERROR: ${e.message}');
      print('RESPONSE: ${e.response?.data}');
      rethrow;
    } catch (e, stack) {
      print('ERROR: $e');
      print('STACKTRACE: $stack');
      rethrow;
    }
  }

  static Future<TrainingPlanResultResponse> getTrainingPlanByType(
    String type,
    int pageNum,
    int pageSize,
  ) async {
    try {
      final response = await DioClient.dio.get(
        ApiEndpoint.getTrainingPlanByType,
        queryParameters: {
          'type': type,
          'page num': pageNum.toString(),
          'page size': pageSize.toString(),
        },
        options: Options(
          contentType: Headers.jsonContentType,
          sendTimeout: Duration(seconds: 5),
          receiveTimeout: Duration(seconds: 5),
        ),
      );

      return TrainingPlanResultResponse.fromJson(response.data);
    } on DioException catch (e) {
      print('DIO ERROR: ${e.message}');
      print('RESPONSE: ${e.response?.data}');
      rethrow;
    } catch (e, stack) {
      print('ERROR: $e');
      print('STACKTRACE: $stack');
      rethrow;
    }
  }

  static Future<ListDefaultResponse> getTrainingExerciseByTargetMuscle(
    String targetMuscle,
    int pageNum,
    int pageSize,
  ) async {
    try {
      final response = await DioClient.dio.get(
        ApiEndpoint.getExerciseByPrimaryMuscle,
        queryParameters: {
          'primary muscle': targetMuscle,
          'page num': pageNum.toString(),
          'page size': pageSize.toString(),
        },
        options: Options(
          contentType: Headers.jsonContentType,
          sendTimeout: Duration(seconds: 5),
          receiveTimeout: Duration(seconds: 5),
        ),
      );

      final data = response.data;
      return ListDefaultResponse<TrainingExercisePreviewLevelResponse>.fromJson(
        data,
        (json) => TrainingExercisePreviewLevelResponse.fromJson(json),
      );
    } on DioException catch (e) {
      print('DIO ERROR: ${e.message}');
      print('RESPONSE: ${e.response?.data}');
      rethrow;
    } catch (e, stack) {
      print('ERROR: $e');
      print('STACKTRACE: $stack');
      rethrow;
    }
  }
}
