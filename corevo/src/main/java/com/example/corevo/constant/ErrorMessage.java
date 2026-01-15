package com.example.corevo.constant;

public class ErrorMessage {
    public static final String ERR_EXCEPTION_GENERAL = "exception.general";
    public static final String UNAUTHORIZED = "exception.unauthorized";
    public static final String FORBIDDEN = "exception.forbidden";
    public static final String BAD_REQUEST = "exception.bad.request";
    public static final String FORBIDDEN_UPDATE_DELETE = "exception.forbidden.update-delete";
    public static final String ERR_UPLOAD_IMAGE_FAIL = "exception.upload.image.fail";

    // error validation dto
    public static final String INVALID_SOME_THING_FIELD = "invalid.general";
    public static final String INVALID_FORMAT_SOME_THING_FIELD = "invalid.general.format";
    public static final String INVALID_SOME_THING_FIELD_IS_REQUIRED = "invalid.general.required";
    public static final String NOT_BLANK_FIELD = "invalid.general.not-blank";
    public static final String INVALID_FORMAT_PASSWORD = "invalid.password-format";
    public static final String INVALID_DATE = "invalid.date-format";
    public static final String INVALID_DATE_FEATURE = "invalid.date-future";
    public static final String INVALID_DATETIME = "invalid.datetime-format";

    public static class Auth {
        public static final String ERR_INCORRECT_USERNAME = "exception.auth.incorrect.username";
        public static final String ERR_INCORRECT_PASSWORD = "exception.auth.incorrect.password";
        public static final String ERR_INVALID_CREDENTIALS = "exception.auth.username.or.password.wrong";
        public static final String ERR_ACCOUNT_NOT_ENABLED = "exception.auth.account.not.enabled";
        public static final String ERR_ACCOUNT_LOCKED = "exception.auth.account.locked";
        public static final String INVALID_REFRESH_TOKEN = "exception.auth.invalid.refresh.token";
        public static final String EXPIRED_REFRESH_TOKEN = "exception.auth.expired.refresh.token";
        public static final String ERR_LOGIN_FAIL = "exception.auth.login.fail";
        public static final String ERR_OTP_EXPIRED_OR_NOT_FOUND = "exception.auth.OTP.expired.or.not.found";
        public static final String ERR_OTP_INVALID = "exception.auth.OTP.invalid";
        public static final String ERR_GET_TOKEN_CLAIM_SET_FAIL = "exception.auth.get.token.claim.set.fail";
        public static final String ERR_TOKEN_INVALIDATED = "exception.auth.token.invalidated";
        public static final String ERR_MALFORMED_TOKEN = "exception.auth.malformed.token";
        public static final String ERR_TOKEN_ALREADY_INVALIDATED = "exception.auth.token.already.invalidated";
        public static final String ERR_INVALID_GOOGLE_TOKEN = "exception.auth.invalid.google.token";

    }

    public static class User {
        public static final String ERR_USER_NOT_EXISTED = "exception.user.user.not.existed";
        public static final String ERR_USERNAME_EXISTED = "exception.user.username.existed";
        public static final String ERR_EMAIL_EXISTED = "exception.user.email.existed";
        public static final String ERR_EMAIL_NOT_EXISTED = "exception.user.email.not.existed";
        public static final String ERR_RE_ENTER_PASSWORD_NOT_MATCH = "exception.user.re-enter.password.not.match";
        public static final String ERR_DUPLICATE_OLD_PASSWORD = "exception.user.duplicate_old_password";
        public static final String ERR_PHONE_EXISTED = "exception.user.phone.existed";
        public static final String ERR_USER_IS_LOCKED = "exception.user.is.locked";
        public static final String ERR_USER_IS_NOT_LOCKED = "exception.user.is.not.locked";
        public static final String ERR_ACCOUNT_ALREADY_DELETED = "exception.user.account.already.deleted";
        public static final String ERR_ACCOUNT_RECOVERY_EXPIRED = "exception.user.account.recovery.period.has.expired";
        public static final String ERR_ACCOUNT_NOT_DELETED = "exception.user.account.is.not.in.deleted.state";
        public static final String ERR_INCORRECT_PASSWORD_CONFIRMATION = "exception.user.incorrect.password.confirmation";
        public static final String ERR_PERSONAL_INFORMATION_NOT_COMPLETED = "exception.user.personal.information.not.completed";
    }

    public static class UserHealth {
        public static final String ERR_USER_HEALTH_NOT_FOUND = "exception.user-health.not.found";
        public static final String ERR_GENDER_REQUIRED = "exception.user-health.gender.required";
        public static final String ERR_ACTIVITY_LEVEL_REQUIRED = "exception.user-health.activity-level.required";
        public static final String ERR_HEIGHT_MIN_VALUE = "exception.user-health.height.min-value";
        public static final String ERR_HEIGHT_MAX_VALUE = "exception.user-health.height.max-value";
        public static final String ERR_WEIGHT_MIN_VALUE = "exception.user-health.weight.min-value";
        public static final String ERR_WEIGHT_MAX_VALUE = "exception.user-health.weight.max-value";
        public static final String ERR_AGE_MIN_VALUE = "exception.user-health.age.min-value";
        public static final String ERR_AGE_MAX_VALUE = "exception.user-health.age.max-value";
    }

    public static class TrainingPlanFlow {
        public static final String ERR_SOMETHING_WRONG = "exception.training-plan.something.wrong";
    }

    public static class Training {
        public static final String ERR_EXERCISE_NOT_EXISTS = "exception.exercise.not.exists";
        public static final String ERR_TRAINING_SCHEDULE_NOT_EXISTS = "exception.training.schedule.not.exists";
        public static final String ERR_NAME_EXERCISE_EXISTS = "exception.name.exercise.exists";
        public static final String ERR_USER_NOT_IN_TRAINING_PLAN = "exception.user.not.in.training.plan";
        public static final String ERR_EXERCISE_NOT_EXISTS_DAY = "exception.exercise.not.exists.today";
        public static final String ERR_EXERCISE_HAS_BEEN_COMPLETED = "exception.exercise.has.been.completed";

        public static final String ERR_TYPE_NOT_EXISTS = "exception.type.not.exists";
        public static final String ERR_TARGET_MUSCLE_NOT_EXISTS = "exception.target.muscle.not.exists";
        public static final String ERR_TRAINING_PLAN_NOT_EXISTS = "exception.training.plan.not.exists";
        public static final String ERR_LOCATION_NOT_EXISTS = "exception.location.not.exists";
        public static final String ERR_LEVEL_NOT_EXISTS = "exception.level.not.exists";
        public static final String ERR_GOAL_NOT_EXISTS = "exception.goal.not.exists";
        public static final String ERR_EQUIPMENT_NOT_EXISTS = "exception.equipment.not.exists";
    }

    public static class Admin {
        public static final String ERR_NOT_ADMIN = "exception.admin.not.admin";
    }

}
