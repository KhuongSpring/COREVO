/**
 * App Strings
 * UI text strings and labels
 * Migrated from Flutter app_string.dart
 */

export const AppStrings = {
    // ============================================
    // GENERAL - Common strings used across app
    // ============================================
    cancel: 'Hủy',
    error: 'Lỗi',
    failed: 'Thất bại',
    loading: 'Đang tải...',
    notification: 'Thông báo',
    ok: 'Xác nhận',
    save: 'Lưu',
    success: 'Thành công',

    // ============================================
    // AUTHENTICATION - Login, Register, Password Reset
    // ============================================
    alreadyHaveAccount: 'Đã có tài khoản?',
    backToLogin: 'Quay lại Đăng nhập',
    dontHaveAccount: 'Chưa có tài khoản?',
    facebookSignIn: 'Tiếp tục với Facebook',
    fillEmailToRecoveryAccount: 'Nhập email của bạn để khôi phục tài khoản',
    fillEmailToResetPassword: 'Nhập email của bạn để đặt lại mật khẩu',
    fillOtp: 'Nhập mã OTP được gửi về email của bạn',
    forgotPassword: 'Quên mật khẩu?',
    forgotPasswordSuccess: 'Link đặt lại mật khẩu đã được gửi',
    generalError: 'Đã xảy ra lỗi, vui lòng thử lại',
    googleSignIn: 'Tiếp tục với Google',
    login: 'Đăng nhập',
    loginFailed: 'Đăng nhập thất bại',
    loginSuccess: 'Đăng  nhập thành công',
    orLoginWith: 'Hoặc đăng nhập bằng',
    orRegisterWith: 'Hoặc đăng ký bằng',
    otpVerification: 'Xác Thực OTP',
    register: 'Đăng ký',
    registerFailed: 'Đăng ký thất bại',
    registerSuccess: 'Đăng ký thành công',
    resendOtp: 'Gửi lại mã OTP',
    resendOtpAfter: 'Gửi lại mã sau',
    resetPassword: 'Đặt lại mật khẩu',
    resetYourPassword: 'Đặt lại mật khẩu mới của bạn',
    sendOtp: 'Gửi mã OTP',
    verify: 'Xác nhận',

    // ============================================
    // HTTP ERRORS - Network and API errors
    // ============================================
    badRequest: 'Yêu cầu không hợp lệ',
    forbidden: 'Không có quyền truy cập',
    invalidResponse: 'Phản hồi không hợp lệ',
    noInternetConnection: 'Không có kết nối internet',
    notFound: 'Không tìm thấy',
    serverError: 'Lỗi máy chủ',
    unauthorized: 'Chưa được xác thực',
    validationError: 'Dữ liệu không hợp lệ',

    // ============================================
    // VALIDATION - Form validation messages
    // ============================================
    emailInvalid: 'Email không hợp lệ',
    emailRequired: 'Email là bắt buộc',
    fieldNotBlank: 'Không được để trống',
    firstNameRequired: 'Họ là bắt buộc',
    lastNameRequired: 'Tên là bắt buộc',
    passwordRequired: 'Mật khẩu là bắt buộc',
    passwordTooShort: 'Mật khẩu phải có ít nhất 6 ký tự',
    phoneIsNotValid: 'Số điện thoại không hợp lệ (10 - 11 số)',
    usernameRequired: 'Tên đăng nhập là bắt buộc',

    // ============================================
    // UI COMMON - Form fields and common UI text
    // ============================================
    activityLevel: 'Mức độ hoạt động',
    age: 'Tuổi',
    agreeTerms: 'Tôi đồng ý với các Chính sách và Điều khoản sử dụng',
    birth: 'Ngày sinh',
    confirmPassword: 'Xác nhận mật khẩu',
    email: 'Email',
    firstName: 'Họ',
    gender: 'Giới tính',
    height: 'Chiều cao',
    lastName: 'Tên',
    nationality: 'Quốc tịch',
    newPassword: 'Mật khẩu mới',
    password: 'Mật khẩu',
    phone: 'Số điện thoại',
    reEnterPassword: 'Nhập lại mật khẩu',
    username: 'Tên đăng nhập',
    weight: 'Cân nặng',

    // ============================================
    // ONBOARDING - Welcome screens
    // ============================================
    welcomeDescription: 'Tôi là Corevo - Trợ lý tập luyện của bạn',
    welcomeSubtitle: 'Sau đây là một số câu hỏi để cá nhân hóa kế hoạch tập luyện dành cho bạn.',
    welcomeTitle: 'Xin chào!',

    // ============================================
    // HEALTH INFORMATION - User health data collection
    // ============================================
    selectionContinue: 'Tiếp tục',

    // Age Selection
    ageSelectionDescription: 'Chọn tuổi của bạn để chúng tôi cá\nhân hóa kế hoạch phù hợp nhất.',
    ageSelectionTitle: 'Tuổi',

    // Gender Selection
    genderSelectionBoy: 'Nam',
    genderSelectionDescription: 'Chọn giới tính của bạn để chúng tôi cá\nhân hóa kế hoạch phù hợp nhất.',
    genderSelectionGirl: 'Nữ',
    genderSelectionTitle: 'Giới Tính',

    // Height Selection
    heightSelectionDescription: 'Chiều cao hiện tại giúp tính toán chỉ số\nthể hình và đề xuất chế độ phù hợp.',
    heightSelectionTitle: 'Chiều Cao',

    // Weight Selection
    weightSelectionDescription: 'Cân nặng hiện tại giúp tính toán chỉ số\nthể hình và đề xuất chế độ phù hợp.',
    weightSelectionTitle: 'Cân Nặng',

    // ============================================
    // ACTIVITY LEVELS - Daily activity tracking
    // ============================================
    activityLevelActive: 'Vận động nhiều',
    activityLevelActiveDescription: 'Tập nặng 6–7 buổi/tuần hoặc lao động chân tay',
    activityLevelLight: 'Vận động nhẹ',
    activityLevelLightDescription: 'Hoạt động nhẹ, đi lại chút ít, tập nhẹ 1–3 buổi/tuần',
    activityLevelModerate: 'Vận động vừa',
    activityLevelModerateDescription: 'Tập trung bình 3–5 buổi/tuần hoặc công việc có đi lại nhiều',
    activityLevelSedentary: 'Ít vận động',
    activityLevelSedentaryDescription: 'Ít vận động, chủ yếu ngồi ',
    activityLevelSelectionDescription: 'Chọn mức độ vận động hàng ngày của bạn\nđể giúp đề xuất kế hoạch phù hợp.',
    activityLevelSelectionTitle: 'Mức Độ Hoạt Động',
    activityLevelSuperActive: 'Rất năng động',
    activityLevelSuperActiveDescription: 'Vận động cường độ cao, 2 buổi/ngày hoặc công việc nặng ',
    level1: 'SEDENTARY',
    level2: 'LIGHTLY_ACTIVE',
    level3: 'MODERATELY_ACTIVE',
    level4: 'VERY_ACTIVE',
    level5: 'SUPER_ACTIVE',

    // ============================================
    // TRAINING - Goal Selection
    // ============================================
    goalSelectionBodyMaintenance: 'Duy trì vóc dáng',
    goalSelectionImproveCardiovascular: 'Cải thiện tim mạch',
    goalSelectionIncreaseEndurance: 'Tăng sức bền',
    goalSelectionIncreaseHeight: 'Tăng chiều cao',
    goalSelectionMuscleGain: 'Tăng cơ',
    goalSelectionReduceStress: 'Giảm stress, thư giãn',
    goalSelectionTitle: 'Mục tiêu luyện tập\ncủa bạn là gì?',
    goalSelectionWeightGain: 'Tăng cân',
    goalSelectionWeightLoss: 'Giảm cân / Giảm mỡ',

    // ============================================
    // TRAINING - Level Selection
    // ============================================
    levelSelectionAdvanced: 'Nâng cao',
    levelSelectionAdvancedDescription: 'Tập cường độ cao, hướng tới mục tiêu rõ ràng',
    levelSelectionBeginner: 'Mới bắt đầu',
    levelSelectionBeginnerDescription: 'Tập nhẹ, làm quen với động tác cơ bản',
    levelSelectionIntermediate: 'Cơ bản',
    levelSelectionIntermediateDescription: 'Đã có nền tảng, muốn nâng cao hiệu quả luyện tập',
    levelSelectionTitle: 'Mức độ kinh nghiệm\ncủa bạn là gì?',

    // ============================================
    // TRAINING - Frequency Selection
    // ============================================
    frequencyDescription1: '"Tôi rất bận rộn, chỉ muốn tập 1 lần mỗi tuần cho đỡ cứng người."',
    frequencyDescription2: '"Tôi muốn bắt đầu nhẹ nhàng, có thời gian thư giãn và chăm sóc bản thân."',
    frequencyDescription3: '"Tôi đang cố gắng duy trì thói quen tập luyện đều đặn mỗi tuần."',
    frequencyDescription4: '"Tôi muốn nâng cao thể lực và cảm thấy cơ thể khỏe mạnh hơn từng ngày."',
    frequencyDescription5: '"Vận động là một phần không thể thiếu trong cuộc sống của tôi."',
    frequencySelectionTitle: 'Bạn thường tập luyện\nbao nhiêu ngày trong tuần?',
    frequencySessionsPerWeek: 'buổi / tuần',

    // ============================================
    // TRAINING - Duration Selection
    // ============================================
    duration1530: '15 - 30 phút',
    duration3045: '30 - 45 phút',
    duration4560: '45 - 60 phút',
    duration60plus: 'Trên 60 phút',
    durationSelectionTitle: 'Thời gian luyện tập\nmà bạn mong muốn?',

    // ============================================
    // TRAINING - Type Selection
    // ============================================
    typeCalisthenic: 'Calisthenic',
    typeCardio: 'Cardio',
    typeGym: 'Gym',
    typeSelectionTitle: 'Hoạt động ưa thích\ncủa bạn là gì?',
    typeYoga: 'Yoga',

    // ============================================
    // TRAINING - Location Selection
    // ============================================
    locationAnywhere: 'Mọi nơi',
    locationGym: 'Phòng gym',
    locationHome: 'Tại nhà',
    locationOutdoor: 'Ngoài trời',
    locationSelectionTitle: 'Địa điểm luyện tập\nmà bạn ưa thích?',

    // ============================================
    // TRAINING - Equipment Selection
    // ============================================
    equipmentDips: 'Xà kép',
    equipmentFullGym: 'Đầy đủ thiết bị Gym',
    equipmentNone: 'Không có',
    equipmentPullUpBar: 'Xà đơn',
    equipmentResistanceBand: 'Dây kháng lực',
    equipmentSelectionTitle: 'Thiết bị luyện tập\nmà bạn có?',
    equipmentTreadmill: 'Máy chạy bộ',
    equipmentYogaMat: 'Thảm yoga',

    // ============================================
    // SETTINGS - App settings and user preferences
    // ============================================
    settingsDarkTheme: 'Chế độ tối',
    settingsDeleteUserData: 'Xóa dữ liệu người dùng',
    settingsFeedback: 'Đánh giá',
    settingsLightTheme: 'Chế độ sáng',
    settingsLogout: 'Đăng xuất',
    settingsLogoutConfirm: 'Bạn có chắc chắn muốn đăng xuất?',
    settingsOverall: 'Cài đặt chung',
    settingsPolicyAndTerms: 'Chính sách & Điều khoản',
    settingsSupportInfor: 'Thông tin hỗ trợ',
    settingsTrainingNotice: 'Nhắc nhở luyện tập',
    settingsUserHealthInfor: 'Thông tin sức khỏe',
    settingsUserInfor: 'Thông tin người dùng',
    settingsUserProfile: 'Hồ sơ người dùng',

    themeAppearance: 'Giao diện',
    themeSettings: 'Cài đặt giao diện',
    themeLight: 'Sáng',
    themeDark: 'Tối',
    themeChangeSuccess: 'Đã thay đổi giao diện thành công',

    // ============================================
    // HOME SCREEN - Dashboard and training overview
    // ============================================
    homeGreeting: 'Xin chào!',
    homeTrainingButton: 'Luyện Tập',
    homeStreakDays: 'Chuỗi',
    homeStreakDaysUnit: 'ngày',
    homeLongestStreak: 'Kỉ lục dài nhất của bạn:',
    homeNextTraining: 'Tiếp theo',
    homeCreateReminder: 'Tạo lời nhắc',
    homeExercises: 'bài tập',

    // Weekday names
    weekdayMonday: 'Thứ Hai',
    weekdayTuesday: 'Thứ Ba',
    weekdayWednesday: 'Thứ Tư',
    weekdayThursday: 'Thứ Năm',
    weekdayFriday: 'Thứ Sáu',
    weekdaySaturday: 'Thứ Bảy',
    weekdaySunday: 'Chủ Nhật',

    // ============================================
    // LIBRARY - Training plans and exercises
    // ============================================
    libraryTabPlans: 'Kế hoạch luyện tập',
    libraryTabExercises: 'Các bài tập',
    librarySearchPlaceholder: 'Tìm kiếm bài tập, kế hoạch...',
    libraryStartButton: 'Bắt đầu',

    // Training Plan Goals (for section headers)
    libraryGoalLoseFat: 'Giảm cân / Giảm mỡ',
    libraryGoalGainWeight: 'Tăng cân',
    libraryGoalGainMuscle: 'Tăng cơ',
    libraryGoalMaintainBody: 'Duy trì vóc dáng',
    libraryGoalIncreaseEndurance: 'Tăng sức bền',
    libraryGoalImproveCardiovascular: 'Cải thiện tim mạch',
    libraryGoalStressRelief: 'Giảm stress, thư giãn',
    libraryGoalIncreaseHeight: 'Tăng chiều cao',

    // Exercise Categories - Muscle Groups
    libraryCategoryChest: 'Ngực',
    libraryCategoryBack: 'Lưng',
    libraryCategoryShoulders: 'Vai',
    libraryCategoryBiceps: 'Tay trước',
    libraryCategoryTriceps: 'Tay sau',
    libraryCategoryAbs: 'Bụng',
    libraryCategoryGlutes: 'Mông',
    libraryCategoryQuads: 'Đùi trước',
    libraryCategoryHamstrings: 'Đùi sau',

    // Exercise Categories - Types
    libraryCategoryCardio: 'Cardio',
    libraryCategoryYoga: 'Yoga',
    libraryCategoryCalisthenic: 'Calisthenic',


} as const;

export type AppStringKey = keyof typeof AppStrings;
