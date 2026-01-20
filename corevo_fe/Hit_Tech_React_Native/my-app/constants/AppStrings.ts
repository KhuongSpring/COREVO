/**
 * App Strings
 * UI text strings and labels
 * Migrated from Flutter app_string.dart
 */

export const AppStrings = {
    success: 'Thành công',
    error: 'Lỗi',
    failed: 'Thất bại',
    notification: 'Thông báo',

    // HTTP Error Strings
    noInternetConnection: 'Không có kết nối internet',
    serverError: 'Lỗi máy chủ',
    invalidResponse: 'Phản hồi không hợp lệ',
    badRequest: 'Yêu cầu không hợp lệ',
    unauthorized: 'Chưa được xác thực',
    forbidden: 'Không có quyền truy cập',
    notFound: 'Không tìm thấy',
    validationError: 'Dữ liệu không hợp lệ',
    forgotPasswordSuccess: 'Link đặt lại mật khẩu đã được gửi',

    // Authentication
    loginFailed: 'Đăng nhập thất bại',
    registerFailed: 'Đăng ký thất bại',
    generalError: 'Đã xảy ra lỗi, vui lòng thử lại',
    loginSuccess: 'Đăng  nhập thành công',
    registerSuccess: 'Đăng ký thành công',

    // Validation
    emailRequired: 'Email là bắt buộc',
    emailInvalid: 'Email không hợp lệ',
    passwordRequired: 'Mật khẩu là bắt buộc',
    passwordTooShort: 'Mật khẩu phải có ít nhất 6 ký tự',
    usernameRequired: 'Tên đăng nhập là bắt buộc',
    firstNameRequired: 'Họ là bắt buộc',
    lastNameRequired: 'Tên là bắt buộc',

    // UI Text
    ok: 'Xác nhận',
    login: 'Đăng nhập',
    register: 'Đăng ký',
    email: 'Email',
    password: 'Mật khẩu',
    newPassword: 'Mật khẩu mới',
    confirmPassword: 'Xác nhận mật khẩu',
    reEnterPassword: 'Nhập lại mật khẩu',
    username: 'Tên đăng nhập',
    firstName: 'Họ',
    lastName: 'Tên',
    agreeTerms: 'Tôi đồng ý với các Chính sách và Điều khoản sử dụng',
    googleSignIn: 'Tiếp tục với Google',
    facebookSignIn: 'Tiếp tục với Facebook',
    orLoginWith: 'Hoặc đăng nhập bằng',
    orRegisterWith: 'Hoặc đăng ký bằng',
    forgotPassword: 'Quên mật khẩu?',
    resetPassword: 'Đặt lại mật khẩu',
    dontHaveAccount: 'Chưa có tài khoản?',
    alreadyHaveAccount: 'Đã có tài khoản?',
    fillEmailToResetPassword: 'Nhập email của bạn để đặt lại mật khẩu',
    fillEmailToRecoveryAccount: 'Nhập email của bạn để khôi phục tài khoản',
    fillOtp: 'Nhập mã OTP được gửi về email của bạn',
    sendOtp: 'Gửi mã OTP',
    backToLogin: 'Quay lại Đăng nhập',
    otpVerification: 'Xác Thực OTP',
    verify: 'Xác nhận',
    resendOtp: 'Gửi lại mã OTP',
    resendOtpAfter: 'Gửi lại mã sau',
    resetYourPassword: 'Đặt lại mật khẩu mới của bạn',
    loading: 'Đang tải...',
    welcomeTitle: 'Xin chào!',
    welcomeDescription: 'Tôi là Corevo - Trợ lý tập luyện của bạn',
    welcomeSubtitle: 'Sau đây là một số câu hỏi để cá nhân hóa kế hoạch tập luyện dành cho bạn.',

    // Health Information
    selectionContinue: 'Tiếp tục',
    genderSelectionTitle: 'Giới Tính',
    genderSelectionDescription: 'Chọn giới tính của bạn để chúng tôi cá\nnhân hóa kế hoạch phù hợp nhất.',
    genderSelectionBoy: 'Nam',
    genderSelectionGirl: 'Nữ',
    ageSelectionTitle: 'Tuổi',
    ageSelectionDescription: 'Chọn tuổi của bạn để chúng tôi cá\nnhân hóa kế hoạch phù hợp nhất.',
    heightSelectionTitle: 'Chiều Cao',
    heightSelectionDescription: 'Chiều cao hiện tại giúp tính toán chỉ số\nthể hình và đề xuất chế độ phù hợp.',
    weightSelectionTitle: 'Cân Nặng',
    weightSelectionDescription: 'Cân nặng hiện tại giúp tính toán chỉ số\nthể hình và đề xuất chế độ phù hợp.',
    activityLevelSelectionTitle: 'Mức Độ Hoạt Động',
    activityLevelSelectionDescription: 'Chọn mức độ vận động hàng ngày của bạn\nđể giúp đề xuất kế hoạch phù hợp.',

    // Activity Levels
    level1: 'SEDENTARY',
    level2: 'LIGHTLY_ACTIVE',
    level3: 'MODERATELY_ACTIVE',
    level4: 'VERY_ACTIVE',
    level5: 'SUPER_ACTIVE',
    activityLevelSedentary: 'Ít vận động',
    activityLevelLight: 'Vận động nhẹ',
    activityLevelModerate: 'Vận động vừa',
    activityLevelActive: 'Vận động nhiều',
    activityLevelSuperActive: 'Rất năng động',
    activityLevelSedentaryDescription: 'Ít vận động, chủ yếu ngồi ',
    activityLevelLightDescription: 'Hoạt động nhẹ, đi lại chút ít, tập nhẹ 1–3 buổi/tuần',
    activityLevelModerateDescription: 'Tập trung bình 3–5 buổi/tuần hoặc công việc có đi lại nhiều',
    activityLevelActiveDescription: 'Tập nặng 6–7 buổi/tuần hoặc lao động chân tay',
    activityLevelSuperActiveDescription: 'Vận động cường độ cao, 2 buổi/ngày hoặc công việc nặng ',

    // Goals
    goalSelectionTitle: 'Mục tiêu luyện tập\ncủa bạn là gì?',
    goalSelectionWeightLoss: 'Giảm cân / Giảm mỡ',
    goalSelectionWeightGain: 'Tăng cân',
    goalSelectionMuscleGain: 'Tăng cơ',
    goalSelectionBodyMaintenance: 'Duy trì vóc dáng',
    goalSelectionIncreaseEndurance: 'Tăng sức bền',
    goalSelectionImproveCardiovascular: 'Cải thiện tim mạch',
    goalSelectionReduceStress: 'Giảm stress, thư giãn',
    goalSelectionIncreaseHeight: 'Tăng chiều cao',

    // Level Selection
    levelSelectionTitle: 'Mức độ kinh nghiệm\ncủa bạn là gì?',
    levelSelectionBeginner: 'Mới bắt đầu',
    levelSelectionIntermediate: 'Cơ bản',
    levelSelectionAdvanced: 'Nâng cao',
    levelSelectionBeginnerDescription: 'Tập nhẹ, làm quen với động tác cơ bản',
    levelSelectionIntermediateDescription: 'Đã có nền tảng, muốn nâng cao hiệu quả luyện tập',
    levelSelectionAdvancedDescription: 'Tập cường độ cao, hướng tới mục tiêu rõ ràng',

    // Frequency Selection
    frequencySelectionTitle: 'Bạn thường tập luyện\nbao nhiêu ngày trong tuần?',
    frequencySessionsPerWeek: 'buổi / tuần',
    frequencyDescription1: '"Tôi rất bận rộn, chỉ muốn tập 1 lần mỗi tuần cho đỡ cứng người."',
    frequencyDescription2: '"Tôi muốn bắt đầu nhẹ nhàng, có thời gian thư giãn và chăm sóc bản thân."',
    frequencyDescription3: '"Tôi đang cố gắng duy trì thói quen tập luyện đều đặn mỗi tuần."',
    frequencyDescription4: '"Tôi muốn nâng cao thể lực và cảm thấy cơ thể khỏe mạnh hơn từng ngày."',
    frequencyDescription5: '"Vận động là một phần không thể thiếu trong cuộc sống của tôi."',

    // Duration Selection
    durationSelectionTitle: 'Thời gian luyện tập\nmà bạn mong muốn?',
    duration1530: '15 - 30 phút',
    duration3045: '30 - 45 phút',
    duration4560: '45 - 60 phút',
    duration60plus: 'Trên 60 phút',

    // Type Selection
    typeSelectionTitle: 'Hoạt động ưa thích\ncủa bạn là gì?',
    typeYoga: 'Yoga',
    typeCalisthenic: 'Calisthenic',
    typeGym: 'Gym',
    typeCardio: 'Cardio',

    // Location Selection
    locationSelectionTitle: 'Địa điểm luyện tập\nmà bạn ưa thích?',
    locationHome: 'Tại nhà',
    locationGym: 'Phòng gym',
    locationOutdoor: 'Ngoài trời',
    locationAnywhere: 'Mọi nơi',

    // Equipment Selection
    equipmentSelectionTitle: 'Thiết bị luyện tập\nmà bạn có?',
    equipmentNone: 'Không có',
    equipmentYogaMat: 'Thảm yoga',
    equipmentTreadmill: 'Máy chạy bộ',
    equipmentResistanceBand: 'Dây kháng lực',
    equipmentFullGym: 'Đầy đủ thiết bị Gym',
    equipmentPullUpBar: 'Xà đơn',
    equipmentDips: 'Xà kép',
} as const;

export type AppStringKey = keyof typeof AppStrings;
