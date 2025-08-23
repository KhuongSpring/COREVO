package com.example.corevo.constant;

public class UrlConstant {
    public static class Auth {
        private static final String PRE_FIX = "/auth";

        public static final String LOGIN = PRE_FIX + "/login";
        public static final String LOGIN_WITH_GOOGLE = PRE_FIX + "/google";
        public static final String REGISTER = PRE_FIX + "/register";
        public static final String VERIFY_OTP = PRE_FIX + "/verify-otp";
        public static final String FORGOT_PASSWORD = PRE_FIX + "/forgot-password";
        public static final String VERIFY_OTP_TO_RESET_PASSWORD = PRE_FIX + "/verify-otp-to-reset-password";
        public static final String RESET_PASSWORD = PRE_FIX + "/reset-password";
        public static final String ACCOUNT_RECOVERY = PRE_FIX + "/account-recovery";
        public static final String VERIFY_OTP_TO_RECOVERY = PRE_FIX + "/verify-otp-to-recovery";
        public static final String RECOVER_ACCOUNT = PRE_FIX + "/recover-account";
        public static final String REFRESH_TOKEN = PRE_FIX + "/refresh";
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
        public static final String DELETE_MY_ACCOUNT = PRE_FIX + "/delete-my-account";

        public static final String GET_PROFILE = PRE_FIX + "/profile";
        public static final String UPDATE_PROFILE = PRE_FIX + "/update-profile";

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
        public static final String SEARCH_USER_BY_USERNAME = PRE_FIX + "/search-user-by-username";
        public static final String SEARCH_USER_BY_EMAIL = PRE_FIX + "/search-user-by-email";
        public static final String SEARCH_USER_BY_PHONE = PRE_FIX + "/search-user-by-phone";

        public static final String SEARCH_TRAINING_EXERCISE = PRE_FIX + "/search-training-exercise";

        public static final String LOCK_USER = PRE_FIX + "/lock-user/{userId}";
        public static final String UNLOCK_USER = PRE_FIX + "/unlock-user/{userId}";

        public static final String GET_ALL_USER = PRE_FIX + "/users-count";

        public static final String GET_ALL_EXERCISE = PRE_FIX + "/exercises";

        public static final String GET_USER_DAY = PRE_FIX + "/user-day";
        public static final String GET_USER_MONTH = PRE_FIX + "/user-month";

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
        public static final String RESET = PRE_FIX + "/reset";
        public static final String GET_BY_TYPE = PRE_FIX;
        private TrainingPlan() {

        }
    }

    public static class Training {
        private static final String PRE_FIX = "/training";
        private static final String PRE_FIX_EXERCISE = PRE_FIX + "/exercise";
        private static final String PRE_FIX_RESOURCE = PRE_FIX + "/resource";
        private static final String PRE_FIX_PROGRESS = PRE_FIX + "/progress";

        public static final String GET_EXERCISE = PRE_FIX_EXERCISE + "/{id}";

        public static final String SEARCH_TRAINING_EXERCISE = PRE_FIX_EXERCISE + "/search";

        public static final String GET_EXERCISE_BY_PRIMARY_MUSCLE = PRE_FIX_EXERCISE + "/target-muscle";
        public static final String GET_EXERCISE_BY_TYPE = PRE_FIX_EXERCISE + "/type";
        public static final String GET_EXERCISE_BY_GOAL = PRE_FIX_EXERCISE + "/goal";

        public static final String SEARCH_TRAINING_PLAN_DYNAMIC = SEARCH_TRAINING_EXERCISE + "/training-plan";
        public static final String SEARCH_TRAINING_EXERCISE_DYNAMIC = SEARCH_TRAINING_EXERCISE + "/training-exercise";

        public static final String GET_TRAINING_PLAN = PRE_FIX_RESOURCE + "/plans";
        public static final String GET_EQUIPMENT = PRE_FIX_RESOURCE + "/equipments";
        public static final String GET_GOAL = PRE_FIX_RESOURCE + "/goals";
        public static final String GET_LEVEL = PRE_FIX_RESOURCE + "/levels";
        public static final String GET_LOCATION = PRE_FIX_RESOURCE + "/locations";
        public static final String GET_TARGET_MUSCLE = PRE_FIX_RESOURCE + "/target-muscles";
        public static final String GET_TYPE = PRE_FIX_RESOURCE + "/types";

        public static final String GET_TYPE_BY_ID = GET_TYPE + "/{id}";
        public static final String GET_TARGET_MUSCLE_BY_ID = GET_TARGET_MUSCLE + "/{id}";
        public static final String GET_TRAINING_PLAN_BY_ID = GET_TRAINING_PLAN + "/{id}";
        public static final String GET_LOCATION_BY_ID = GET_LOCATION + "/{id}";
        public static final String GET_LEVEL_BY_ID = GET_LEVEL + "/{id}";
        public static final String GET_GOAL_BY_ID = GET_GOAL + "/{id}";
        public static final String GET_EQUIPMENT_BY_ID = GET_EQUIPMENT + "/{id}";

        public static final String GET_TRAINING_SCHEDULE = PRE_FIX + "/schedule";

        public static final String COMPLETE_EXERCISE = PRE_FIX_PROGRESS + "/complete";
        public static final String GET_DAILY_PROGRESS = PRE_FIX_PROGRESS + "/daily";
        public static final String GET_WEEKLY_PROGRESS = PRE_FIX_PROGRESS + "/weekly";
        public static final String GET_COMPLETED_STATISTIC = PRE_FIX_PROGRESS +"/statistic";


        private Training() {

        }
    }

    public static class Policy {
        private static final String PRE_FIX = "/policy";
        
        public static final String GET_PRIVACY_POLICY = PRE_FIX + "/privacy";
        public static final String GET_TERMS_OF_SERVICE = PRE_FIX + "/terms";
        
        private Policy() {
        }
    }

}
