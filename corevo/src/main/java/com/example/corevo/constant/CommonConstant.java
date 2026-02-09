package com.example.corevo.constant;

import java.time.ZoneId;

public class CommonConstant {
    // Common
    public static final String ADMIN_EMAIL = "corevo@gmail.com";

    // Sorting
    public static final String SORT_TYPE_ASC = "ASC";
    public static final String SORT_TYPE_DESC = "DESC";

    // Pagination
    public static final Integer PAGE_SIZE_DEFAULT = 10;

    // Account Management
    public static final Integer ACCOUNT_RECOVERY_DAYS = 30;

    // Numeric Values
    public static final Integer ZERO_INT_VALUE = 0;
    public static final Integer ONE_INT_VALUE = 1;
    public static final Long ZERO_VALUE = 0L;
    public static final Long ONE_VALUE = 1L;

    // String Values
    public static final String EMPTY_STRING = "";
    public static final String BEARER_TOKEN = "Bearer";

    // Date/Time
    public static final String PATTERN_DATE_TIME = "yyyy-MM-dd HH:mm:ss";
    public static final String PATTERN_DATE = "yyyy-MM-dd";
    public static final ZoneId APPLICATION_TIMEZONE = ZoneId.of("Asia/Ho_Chi_Minh");

    // OTP Configuration
    public static final int OTP_EXPIRATION_MINUTES = 5;
    public static final int OTP_LENGTH = 6;
    public static final int OTP_MIN_VALUE = 100000;
    public static final int OTP_MAX_VALUE = 999999;

    // Security
    public static final int BCRYPT_STRENGTH = 10;

    // File Types
    public static final String CONTENT_TYPE_DOCUMENT = "txt doc pdf ppt pps xlsx xls docx";
    public static final String CONTENT_TYPE_IMAGE = "png jpg jpeg webp gif";
    public static final String CONTENT_TYPE_VIDEO = "mp4 mpg mpe mpeg webm mov m4v";

    // Health Metrics Validation
    public static final int MIN_HEIGHT = 50;
    public static final int MAX_HEIGHT = 250;

    public static final int MIN_WEIGHT = 30;
    public static final int MAX_WEIGHT = 300;

    public static final int MIN_AGE = 10;
    public static final int MAX_AGE = 100;

    public static final int MAX_POST_LENGTH = 5000;
    public static final int MAX_COMMENT_LENGTH = 1000;
    public static final int MAX_MEDIA_PER_POST = 10;
    public static final int MAX_HASHTAGS_PER_POST = 10;
    public static final int MAX_MENTIONS_PER_POST = 20;
    public static final int DEFAULT_PAGE_SIZE = 20;
    public static final int MAX_COMMENT_DEPTH = 2; // Limit nested comments
}
