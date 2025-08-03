import 'package:dio/dio.dart';
import 'package:hit_tech/service/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../service/auth_service.dart';

class DioClient {
  static final Dio dio = Dio()
    ..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          String? accessToken = await SharedPreferencesService.getAccessToken();

          if (accessToken != null && JwtDecoder.isExpired(accessToken)) {
            final newToken = await AuthService.refreshAccessToken();
            if (newToken != null) {
              accessToken = newToken;
            } else {
              await SharedPreferencesService.logout();
              return handler.reject(
                DioException(
                  requestOptions: options,
                  error: 'Token expired, please login again.',
                ),
              );
            }
          }

          if (accessToken != null) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }

          return handler.next(options);
        },
      ),
    );
}
