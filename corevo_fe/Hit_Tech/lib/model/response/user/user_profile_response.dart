import 'package:hit_tech/model/response/training/training_plan_response.dart';
import 'package:hit_tech/model/response/user/user_health_response.dart';

class UserProfileResponse {
  final String status;
  String? id;
  String? username;
  String? email;
  String? firstName;
  String? lastName;
  String? birth;
  String? phone;
  String? nationality;
  String? linkAvatar;
  UserHealthResponse? userHealth;
  List<TrainingPlanResponse>? trainingPlans;

  UserProfileResponse({
    required this.status,
    this.id,
    this.username,
    this.email,
    this.firstName,
    this.lastName,
    this.birth,
    this.phone,
    this.nationality,
    this.linkAvatar,
    this.userHealth,
    this.trainingPlans,
  });

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return UserProfileResponse(
      status: json['status'],
      id: data['id'],
      username: data['username'],
      email: data['email'],
      firstName: data['firstName'],
      lastName: data['lastName'],
      birth: data['birth'],
      phone: data['phone'],
      nationality: data['nationality'],
      linkAvatar: data['linkAvatar'],
      userHealth: data['userHealth'] != null
          ? UserHealthResponse.fromJson(data['userHealth'])
          : null,
      trainingPlans: data['trainingPlans'] != null
          ? (data['trainingPlans'] as List)
          .map((e) => TrainingPlanResponse.fromJson(e))
          .toList()
          : null,
    );
  }
}
