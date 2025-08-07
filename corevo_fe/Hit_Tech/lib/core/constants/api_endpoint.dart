abstract class ApiEndpoint {
  // static const String baseUrl = 'http://192.168.184.103:8080';

  // Máy Khương
  static const String baseUrl = 'http://10.0.2.2:8080';
  // static const String baseUrl = 'http://192.168.50.240:8080';
  // static const String baseUrl = 'http://146.190.101.127:8080';

  // Base Endpoints
  static const String version = '$baseUrl/api/v1';
  static const String userEndpoint = '$version/user';
  static const String userHealthEndpoint = '$version/user-health';
  static const String trainingProgress = '$version/training/progress';
  static const String trainingExercise = '$version/training/exercise';
  static const String trainingPlanFlow = '$version/training-plan';
  static const String auth = '$version/auth';
  static const String trainingSchedule = '$version/training/schedule';
  static const String trainingResource = '$version/training/resource';
  static const String policy = '$version/policy';

  // User Endpoint
  static const String updateProfile = '$userEndpoint/update-profile';
  static const String uploadAvatar = '$userEndpoint/upload-avatar';
  static const String fillPersonalInformation =
      '$userEndpoint/personal-information';
  static const String getProfile = '$userEndpoint/profile';
  static const String deleteMyAccount = '$userEndpoint/delete-my-account';

  // User-health Endpoint
  static const String fillHeathInformation =
      '$userHealthEndpoint/health-information';

  // Training Controller Progress
  static const String completeExercise =
      '$trainingProgress/complete';
  static const String getWeeklyProgress =
      '$trainingProgress/weekly';
  static const String getStatistic =
      '$trainingProgress/statistic';
  static const String getDailyProgress =
      '$trainingProgress/daily';


  // Training-exercise-search
  static const String searchExercise = '$trainingExercise/search';
  static String getExercise(int id) => '$trainingExercise/$id';
  static const String getExerciseByType = '$trainingExercise/type';
  static const String getExerciseByPrimaryMuscle =
      '$trainingExercise/target-muscle';
  static const String getExerciseByGoal = '$trainingExercise/goal';
  static const String getTrainingPlanByType = trainingPlanFlow;

  // Training-plan-flow
  static const String flowStep = '$trainingPlanFlow/step';
  static const String reset = '$trainingPlanFlow/reset';

  // Auth Endpoints
  static const String verifyOtp = '$auth/verify-otp';
  static const String verifyOptResetPassword =
      '$auth/verify-otp-to-reset-password';
  static const String verifyOptRecovery = '$auth/verify-opt-to-recovery';
  static const String resetPassword = '$auth/reset-password';
  static const String register = '$auth/register';
  static const String refreshToken = '$auth/refresh';
  static const String recoverAccount = '$auth/recover-account';
  static const String logout = '$auth/logout';
  static const String login = '$auth/login';
  static const String sendEmailToForgotPassword = '$auth/forgot-password';
  static const String sendEmailToAccountRecovery = '$auth/account-recovery';
  static const String loginWithGoogle = '$auth/google';

  // Training-schedule
  static const String getTrainingSchedule = trainingSchedule;

  // Training-resource
  static const String getAllTrainingType = '$trainingResource/types';
  static const String getAllTrainingTargetMuscle =
      '$trainingResource/target-muscles';
  static const String getAllTrainingPlan = '$trainingResource/plans';
  static const String getAllTrainingLocation = '$trainingResource/locations';
  static const String getAllTrainingLevel = '$trainingResource/levels';
  static const String getAllTrainingGoal = '$trainingResource/goals';
  static const String getAllTrainingEquipment = '$trainingResource/equipments';

  // Policy
  static const String getPolicyTerms = '$policy/terms';
  static const String getPolicyPrivacy = '$policy/privacy';
}
