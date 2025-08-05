import 'dart:convert';
import 'package:hit_tech/service/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/api_endpoint.dart';

class SharedPreferencesService {
  static const String _accessTokenKey = 'auth_access_token';
  static const String _refreshTokenKey = 'auth_refresh_token';
  static const String _userKey = 'user_data';

  // Token methods
  static Future<void> saveAccessToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_accessTokenKey, token);
    } catch (e) {
      print('Error saving token: $e');
      rethrow;
    }
  }

  static Future<String?> getAccessToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_accessTokenKey);
    } catch (e) {
      print('Error getting token: $e');
      return null;
    }
  }

  static Future<void> saveRefreshToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_refreshTokenKey, token);
    } catch (e) {
      print('Error saving token: $e');
      rethrow;
    }
  }

  static Future<String?> getRefreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_refreshTokenKey);
    } catch (e) {
      print('Error getting token: $e');
      return null;
    }
  }

  // User data methods with proper JSON serialization
  static Future<void> saveUserData(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataJson = jsonEncode(userId);
      await prefs.setString(_userKey, userDataJson);
    } catch (e) {
      print('Error saving user data: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>?> getUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString(_userKey);

      if (userDataString == null) return null;

      return jsonDecode(userDataString) as Map<String, dynamic>;
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  // Utility methods
  static Future<void> clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      print('Error clearing preferences: $e');
      rethrow;
    }
  }

  static Future<void> removeToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_accessTokenKey);
      await prefs.remove(_refreshTokenKey);
    } catch (e) {
      print('Error removing token: $e');
      rethrow;
    }
  }

  static Future<void> removeUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userKey);
    } catch (e) {
      print('Error removing user data: $e');
      rethrow;
    }
  }

  static Future<bool> isLoggedIn() async {
    try {
      final refreshToken = await getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) return false;

      final response = await http.post(
        Uri.parse(ApiEndpoint.refreshToken),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refreshToken': refreshToken}),
      );

      if (response.statusCode == 403) {
        await clearAll();
        return false;
      }

      return response.statusCode == 200;
    } catch (e) {
      print('Error checking login status: $e');
      return false;
    }
  }

  // Additional utility methods
  static Future<bool> hasUserData() async {
    try {
      final userData = await getUserData();
      return userData != null && userData.isNotEmpty;
    } catch (e) {
      print('Error checking user data: $e');
      return false;
    }
  }

  static Future<void> logout() async {
    try {
      final token = await getAccessToken();

      if (token != null) {
        await AuthService.logout(token);
      }

      await clearAll();
    } catch (e) {
      print('Error during logout: $e');
      rethrow;
    }
  }

  static bool isExpired(String token) {
    return JwtDecoder.isExpired(token);
  }

}