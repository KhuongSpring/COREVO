package com.example.corevo.constant;

public class SuccessMessage {
    public static class Auth {
        public static final String SUCCESS_SEND_OTP = "OTP has sent to your email";
    }
    
    public static class User {
        public static final String DELETE_SUCCESS = "Delete user successfully";
        public static final String LOCKED_SUCCESS = "Locked user successfully";
        public static final String UNLOCKED_SUCCESS = "Unlocked user successfully";
        public static final String SOFT_DELETE_SUCCESS = "User account has been deleted successfully. You have 30 days to recover it.";
        public static final String RECOVERY_SUCCESS = "User account has been recovered successfully";
    }
}
