import 'dart:convert';

import 'package:hit_tech/model/response/default_response.dart';
import 'package:hit_tech/model/response/user/user_profile_response.dart';
import 'package:http/http.dart' as http;

import '../core/constants/api_endpoint.dart';
import '../model/request/personal_health_request.dart';
import 'shared_preferences.dart';

class UserService {
  static Future<DefaultResponse> fillPersonalHealth(
      PersonalHealthRequest request
      ) async {
    final token = await SharedPreferencesService.getAccessToken();

    final response = await http.post(
      Uri.parse(ApiEndpoint.fillHeathInformation),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(request.toJson()),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return DefaultResponse.fromJson(data);
    } else {
      throw Exception('Get profile failed');
    }
  }

  static Future<UserProfileResponse> getProfile() async {
    final token = await SharedPreferencesService.getAccessToken();

    final response = await http.get(
      Uri.parse(ApiEndpoint.getProfile),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return UserProfileResponse.fromJson(data);
    } else {
      throw Exception('Get profile failed');
    }
  }
}
