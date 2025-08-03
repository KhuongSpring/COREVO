import 'package:hit_tech/core/constants/app_string.dart';

class ValidatorUtil {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.emailRequired;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return AppStrings.emailInvalid;
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.passwordRequired;
    }

    if (value.length < 6) {
      return AppStrings.passwordTooShort;
    }

    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName là bắt buộc';
    }
    return null;
  }

  static String? validateUsername(String? value) {
    return validateRequired(value, 'Tên đăng nhập');
  }

  static String? validateFirstName(String? value) {
    return validateRequired(value, 'Họ');
  }

  static String? validateLastName(String? value) {
    return validateRequired(value, 'Tên');
  }
}