/**
 * App Messages
 * Error and success messages for the application
 * Migrated from Flutter app_message.dart
 */

// HTTP Error Messages
export const HttpMessage = {
    errGeneral: 'Lỗi không xác định',
    errNoInternetConnection: 'Không có kết nối internet. Vui lòng kiểm tra lại.',
    errServer: 'Máy chủ gặp sự cố. Vui lòng thử lại sau.',
    errBadRequest: 'Yêu cầu không hợp lệ. Vui lòng kiểm tra lại thông tin.',
    errUnauthorized: 'Bạn chưa đăng nhập hoặc phiên đăng nhập đã hết hạn.',
    errForbidden: 'Bạn không có quyền truy cập chức năng này.',
    errNotFound: 'Không tìm thấy dữ liệu yêu cầu.',
    errConflict: 'Dữ liệu đã tồn tại.',
    errTooManyRequest: 'Bạn đã gửi quá nhiều yêu cầu. Vui lòng chờ một lúc.',
} as const;

// Validation Messages
export const ValidationMessage = {
    errInvalidSomethingField: 'Trường không hợp lệ.',
    errInvalidFormatSomeThingField: 'Định dạng trường không hợp lệ.',
    errInvalidSomethingFieldIsRequired: 'Trường này là bắt buộc.',
    errInvalidFormatPassword: 'Mật khẩu phải chứa ít nhất 1 chữ hoa, 1 chữ thường, 1 số và 1 ký tự đặc biệt.',
    errInvalidDate: 'Ngày không hợp lệ.',
    errNotBlankField: 'Trường này không được để trống.',
    errInvalidPasswordLength: 'Mật khẩu phải có ít nhất 6 ký tự.',
    errPasswordMismatch: 'Mật khẩu không khớp.',

    errInvalidUsername: 'Tên người dùng không hợp lệ.',
    errInvalidPassword: 'Mật khẩu không hợp lệ.',
    errInvalidEmail: 'Email không hợp lệ.',
    errInvalidPhoneNumber: 'Số điện thoại không hợp lệ.',

    errPasswordRequired: 'Vui lòng nhập mật khẩu.',
    errFirstNameRequired: 'Vui lòng nhập họ.',
    errLastNameRequired: 'Vui lòng nhập tên.',
    errPolicyRequired: 'Bạn phải đồng ý với điều khoản.',
    errMailRequired: 'Vui lòng nhập email.',
    errUsernameOrEmailRequired: 'Vui lòng nhập tên đăng nhập hoặc email.',

    errUsernameTooShort: 'Tên người dùng quá ngắn.',
    errPasswordTooShort: 'Mật khẩu quá ngắn.',

    errReEnterPasswordNotMatch: 'Mật khẩu nhập lại không khớp.',
    errDuplicateOldPassword: 'Mật khẩu mới không được trùng mật khẩu cũ.',
} as const;

// Authentication Messages
export const AuthMessage = {
    // Errors
    errIncorrectUsername: 'Tên người dùng không chính xác.',
    errIncorrectPassword: 'Mật khẩu không chính xác.',
    errAccountNotEnabled: 'Tài khoản chưa được kích hoạt.',
    errAccountLocked: 'Tài khoản của bạn đã bị khóa.',
    errLoginFail: 'Đăng nhập thất bại. Vui lòng kiểm tra lại.',
    errRegisterFail: 'Đăng ký thất bại. Vui lòng thử lại.',
    errOtpExpiredOrNotFound: 'OTP đã hết hạn hoặc không tồn tại.',
    errOtpInvalid: 'OTP không hợp lệ.',
    errSendOtpFailed: 'Gửi OTP thất bại. Vui lòng thử lại.',
    errResetPasswordFail: 'Đặt lại mật khẩu thất bại. Vui lòng thử lại.',

    // Success
    sucSendOtp: 'Vui lòng kiểm tra email để xác thực tài khoản.',
    sucVerifyOtp: 'Xác thực OTP thành công.',
    sucLogin: 'Đăng nhập thành công.',
    sucRegister: 'Đăng ký thành công.',
    sucLogout: 'Đăng xuất thành công.',
    sucResetPassword: 'Đặt lại mật khẩu thành công.',
    sucDelete: 'Xóa tài khoản thành công.',
    sucLocked: 'Khóa tài khoản thành công.',
    sucUnLocked: 'Mở khóa tài khoản thành công.',
    sucSoftDelete: 'Xóa mềm tài khoản thành công.',
    sucRecovery: 'Khôi phục tài khoản thành công.',
} as const;

// User Messages
export const UserMessage = {
    // Errors
    errUsernameExisted: 'Tên người dùng đã tồn tại.',
    errEmailExisted: 'Email đã được sử dụng.',
    errPhoneExisted: 'Số điện thoại đã được sử dụng.',
    errUserIsLocked: 'Người dùng đã bị khóa.',
    errUserIsNotLocked: 'Người dùng chưa bị khóa.',
    errAccountAlreadyDeleted: 'Tài khoản đã bị xóa.',
    errAccountRecoveryExpired: 'Thời gian khôi phục tài khoản đã hết.',
    errAccountNotDeleted: 'Tài khoản chưa bị xóa.',
    errIncorrectPasswordConfirmation: 'Xác nhận mật khẩu không đúng.',
    errPersonalInformationNotCompleted: 'Thông tin cá nhân chưa được hoàn tất.',
    errInvalidImage: 'Ảnh tải lên không hợp lệ.',
    errEmailNotExist: 'Email không chính xác',

    // Success
    sucUpdateProfile: 'Cập nhật hồ sơ thành công.',
    sucUploadAvatar: 'Tải ảnh đại diện thành công.',
    sucFillPersonalInformation: 'Điền thông tin cá nhân thành công.',
} as const;

// User Health Messages
export const UserHealthMessage = {
    // Errors
    errUserHealthNotFound: 'Không tìm thấy thông tin sức khỏe người dùng.',
    errGenderRequired: 'Vui lòng chọn giới tính.',
    errActivityLevelRequired: 'Vui lòng chọn mức độ hoạt động.',
    errHeightMinValue: 'Chiều cao quá thấp.',
    errHeightMaxValue: 'Chiều cao vượt quá giới hạn.',
    errWeightMinValue: 'Cân nặng quá thấp.',
    errWeightMaxValue: 'Cân nặng vượt quá giới hạn.',
    errAgeMinValue: 'Tuổi quá nhỏ.',
    errAgeMaxValue: 'Tuổi vượt quá giới hạn.',

    // Success
    sucFillPersonalHealth: 'Cập nhật thông tin sức khỏe thành công.',
} as const;

// Training Flow Messages
export const TrainingFlowMessage = {
    // Errors
    errSomethingWrong: 'Đã xảy ra lỗi trong quá trình thiết lập kế hoạch luyện tập.',

    // Success
    sucTrainingFlow: 'Thiết lập kế hoạch luyện tập thành công.',
    sucTrainingReset: 'Đặt lại kế hoạch luyện tập thành công.',
} as const;

// Training Messages
export const TrainingMessage = {
    // Errors
    errExerciseNotExisted: 'Bài tập không tồn tại.',
    errTrainingPlanNotExisted: 'Kế hoạch luyện tập không tồn tại.',
    errTrainingScheduleNotExisted: 'Lịch tập không tồn tại.',
} as const;

// Export all messages
export const AppMessages = {
    http: HttpMessage,
    validation: ValidationMessage,
    auth: AuthMessage,
    user: UserMessage,
    userHealth: UserHealthMessage,
    trainingFlow: TrainingFlowMessage,
    training: TrainingMessage,
} as const;
