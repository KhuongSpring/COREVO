import 'dart:convert';

import 'package:hit_tech/model/response/user/user_profile_response.dart';
import 'package:http/http.dart' as http;

import '../core/constants/api_endpoint.dart';
import 'shared_preferences.dart';

class UserService {
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
