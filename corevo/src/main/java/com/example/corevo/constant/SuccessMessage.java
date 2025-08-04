package com.example.corevo.constant;

public class SuccessMessage {
    public static class Auth {
        public static final String SUCCESS_SEND_OTP = "OTP has sent to your email";
        public static final String LOGIN_SUCCESS = "Login successfully";
        public static final String LOGOUT_SUCCESS = "Logout successfully";
    }

    public static class User {
        public static final String DELETE_SUCCESS = "Delete user successfully";
        public static final String LOCKED_SUCCESS = "Locked user successfully";
        public static final String UNLOCKED_SUCCESS = "Unlocked user successfully";
        public static final String SOFT_DELETE_SUCCESS = "User account has been deleted successfully. You have 30 days to recover it.";
        public static final String RECOVERY_SUCCESS = "User account has been recovered successfully";
    }

    public static class TrainingPlan {
        public static final String RESET_TRAINING_PLAN_SUCCESS = "Reset training plan successfully";
    }

    public static class Exercise {
        public static final String COMPLETE_EXERCISE_SUCCESS = "Exercise completed successfully";
    }
}
