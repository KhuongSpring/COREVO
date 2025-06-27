package com.example.corevo.constant;

public class UrlConstant {
    public static class Auth {
        private static final String PRE_FIX = "/auth";

        public static final String LOGIN = PRE_FIX + "/login";
        public static final String REGISTER = PRE_FIX + "/register";
        public static final String VERIFY_OTP = PRE_FIX + "/verify-otp";
        public static final String FORGOT_PASSWORD = PRE_FIX + "/forgot-password";
        public static final String VERIFY_OTP_TO_RESET_PASSWORD = PRE_FIX + "/verify-otp-to-reset-password";
        public static final String RESET_PASSWORD = PRE_FIX + "/reset-password";
        public static final String SEND_ACCOUNT_RECOVERY_OTP = PRE_FIX + "/send-account-recovery-otp";
        public static final String VERIFY_OTP_TO_RECOVERY = PRE_FIX + "/verify-otp-to-recovery";
        public static final String LOGOUT = PRE_FIX + "/logout";

        private Auth() {
        }
    }

    public static class User {
        private static final String PRE_FIX = "/user";

        public static final String GET_USERS = PRE_FIX;
        public static final String GET_USER = PRE_FIX + "/{userId}";
        public static final String GET_CURRENT_USER = PRE_FIX + "/current";

        public static final String FILL_PERSONAL_INFORMATION = PRE_FIX + "/personal-information";
        public static final String UPLOAD_AVATAR = PRE_FIX + "/upload-avatar";

        private User() {
        }
    }

    public static class Admin {
        private static final String PRE_FIX = "/admin";

        public static final String GET_USERS = PRE_FIX + "/users";
        public static final String GET_USER = PRE_FIX + "/users/{userId}";
        public static final String CREATE_USER = PRE_FIX + "/create-user";
        public static final String UPDATE_USER = PRE_FIX + "/update-user/{userId}";
        public static final String DELETE_USER = PRE_FIX + "/delete-user/{userId}";

        public static final String LOCK_USER = PRE_FIX + "/lock-user/{userId}";
        public static final String UNLOCK_USER = PRE_FIX + "/unlock-user/{userId}";

        private Admin() {
        }
    }

    public static class UserHealth {
        private static final String PRE_FIX = "/user-health";
        public static final String FILL_HEALTH_INFORMATION = PRE_FIX + "/health-information";

        private UserHealth() {

        }
    }

    public static class TrainingPlan {
        private static final String PRE_FIX = "/training-plan";
        public static final String FLOW_STEP = PRE_FIX + "/step";

        private TrainingPlan() {

        }
    }

}
