class HttpMessage {
  // Error message
  static const String errGeneral = 'Lỗi không xác định';
  static const String errNoInternetConnection =
      'Không có kết nối internet. Vui lòng kiểm tra lại.';
  static const String errServer = 'Máy chủ gặp sự cố. Vui lòng thử lại sau.';
  static const String errBadRequest =
      'Yêu cầu không hợp lệ. Vui lòng kiểm tra lại thông tin.';
  static const String errUnauthorized =
      'Bạn chưa đăng nhập hoặc phiên đăng nhập đã hết hạn.';
  static const String errForbidden =
      'Bạn không có quyền truy cập chức năng này.';
  static const String errNotFound = 'Không tìm thấy dữ liệu yêu cầu.';
  static const String errConflict = 'Dữ liệu đã tồn tại.';
  static const String errTooManyRequest =
      'Bạn đã gửi quá nhiều yêu cầu. Vui lòng chờ một lúc.';
}

class ValidationMessage {
  // Error message
  static const String errInvalidSomethingField = 'Trường không hợp lệ.';
  static const String errInvalidFormatSomeThingField =
      'Định dạng trường không hợp lệ.';
  static const String errInvalidSomethingFieldIsRequired =
      'Trường này là bắt buộc.';
  static const String errInvalidFormatPassword =
      'Mật khẩu phải chứa ít nhất 1 chữ hoa, 1 chữ thường, 1 số và 1 ký tự đặc biệt.';
  static const String errInvalidDate = 'Ngày không hợp lệ.';

  static const String errNotBlankField = 'Trường này không được để trống.';

  static const String errInvalidUsername = 'Tên người dùng không hợp lệ.';
  static const String errInvalidPassword = 'Mật khẩu không hợp lệ.';
  static const String errInvalidEmail = 'Email không hợp lệ.';
  static const String errInvalidPhoneNumber = 'Số điện thoại không hợp lệ.';

  static const String errUsernameRequired = 'Vui lòng nhập tên người dùng.';
  static const String errPasswordRequired = 'Vui lòng nhập mật khẩu.';
  static const String errEmailRequired = 'Vui lòng nhập email.';
  static const String errFirstNameRequired = 'Vui lòng nhập họ.';
  static const String errLastNameRequired = 'Vui lòng nhập tên.';
  static const String errPolicyRequired = 'Bạn phải đồng ý với điều khoản.';

  static const String errUsernameTooShort = 'Tên người dùng quá ngắn.';
  static const String errPasswordTooShort = 'Mật khẩu quá ngắn.';

  static const String errReEnterPasswordNotMatch =
      'Mật khẩu nhập lại không khớp.';
  static const String errDuplicateOldPassword =
      'Mật khẩu mới không được trùng mật khẩu cũ.';
}

class AuthMessage {
  // Error message
  static const String errIncorrectUsername = 'Tên người dùng không chính xác.';
  static const String errIncorrectPassword = 'Mật khẩu không chính xác.';

  static const String errAccountNotEnabled = 'Tài khoản chưa được kích hoạt.';
  static const String errAccountLocked = 'Tài khoản của bạn đã bị khóa.';

  static const String errLoginFail =
      'Đăng nhập thất bại. Vui lòng kiểm tra lại.';
  static const String errRegisterFail = 'Đăng ký thất bại. Vui lòng thử lại.';

  static const String errOtpExpiredOrNotFound =
      'OTP đã hết hạn hoặc không tồn tại.';
  static const String errOtpInvalid = 'OTP không hợp lệ.';

  // Success message
  static const String sucSendOtp = 'Gửi mã OTP thành công.';
  static const String sucVerifyOtp = 'Xác thực OTP thành công.';
  static const String sucLogin = 'Đăng nhập thành công.';
  static const String sucRegister = 'Đăng ký thành công.';
  static const String sucLogout = 'Đăng xuất thành công.';
  static const String sucResetPassword = 'Đặt lại mật khẩu thành công.';
  static const String sucDelete = 'Xóa tài khoản thành công.';
  static const String sucLocked = 'Khóa tài khoản thành công.';
  static const String sucUnLocked = 'Mở khóa tài khoản thành công.';
  static const String sucSoftDelete = 'Xóa mềm tài khoản thành công.';
  static const String sucRecovery = 'Khôi phục tài khoản thành công.';
}

class UserMessage {
  // Error message
  static const String errUsernameExisted = 'Tên người dùng đã tồn tại.';
  static const String errEmailExisted = 'Email đã được sử dụng.';
  static const String errPhoneExisted = 'Số điện thoại đã được sử dụng.';

  static const String errUserIsLocked = 'Người dùng đã bị khóa.';
  static const String errUserIsNotLocked = 'Người dùng chưa bị khóa.';

  static const String errAccountAlreadyDeleted = 'Tài khoản đã bị xóa.';
  static const String errAccountRecoveryExpired =
      'Thời gian khôi phục tài khoản đã hết.';
  static const String errAccountNotDeleted = 'Tài khoản chưa bị xóa.';

  static const String errIncorrectPasswordConfirmation =
      'Xác nhận mật khẩu không đúng.';
  static const String errPersonalInformationNotCompleted =
      'Thông tin cá nhân chưa được hoàn tất.';

  static const String errInvalidImage = 'Ảnh tải lên không hợp lệ.';

  static const String errEmailNotExist = 'Email không chính xác';

  // Success message
  static const String sucUpdateProfile = 'Cập nhật hồ sơ thành công.';
  static const String sucUploadAvatar = 'Tải ảnh đại diện thành công.';
  static const String sucFillPersonalInformation =
      'Điền thông tin cá nhân thành công.';
}

class UserHealthMessage {
  // Error message
  static const String errUserHealthNotFound =
      'Không tìm thấy thông tin sức khỏe người dùng.';
  static const String errGenderRequired = 'Vui lòng chọn giới tính.';
  static const String errActivityLevelRequired =
      'Vui lòng chọn mức độ hoạt động.';
  static const String errHeightMinValue = 'Chiều cao quá thấp.';
  static const String errHeightMaxValue = 'Chiều cao vượt quá giới hạn.';
  static const String errWeightMinValue = 'Cân nặng quá thấp.';
  static const String errWeightMaxValue = 'Cân nặng vượt quá giới hạn.';
  static const String errAgeMinValue = 'Tuổi quá nhỏ.';
  static const String errAgeMaxValue = 'Tuổi vượt quá giới hạn.';

  // Success message
  static const String sucFillPersonalHealth =
      'Cập nhật thông tin sức khỏe thành công.';
}

class TrainingFlowMessage {
  // Error message
  static const String errSomethingWrong =
      'Đã xảy ra lỗi trong quá trình thiết lập kế hoạch luyện tập.';

  // Success message
  static const String sucTrainingFlow =
      'Thiết lập kế hoạch luyện tập thành công.';
  static const String sucTrainingReset =
      'Đặt lại kế hoạch luyện tập thành công.';
}

class TrainingMessage {
  // Error message
  static const String errExerciseNotExisted = 'Bài tập không tồn tại.';
  static const String errTrainingPlanNotExisted =
      'Kế hoạch luyện tập không tồn tại.';
  static const String errTrainingScheduleNotExisted = 'Lịch tập không tồn tại.';
}
