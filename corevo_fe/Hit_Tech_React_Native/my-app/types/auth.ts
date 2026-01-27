/**
 * Authentication Types
 * Request and Response interfaces for auth endpoints
 */

// ===== Login =====

export interface LoginRequest {
    username: string;
    password: string;
}

export interface LoginResponse {
    status: string;
    message?: string;
    accessToken?: string;
    refreshToken?: string;
    id?: string;
    isDeleted?: boolean;
    canRecovery?: boolean;
    dayRecoveryRemaining?: number;
}

// ===== Register =====

export interface RegisterRequest {
    username: string;
    email: string;
    password: string;
    firstName: string;
    lastName: string;
}

export interface RegisterResponse {
    status: string;
    message?: string;
    userId?: string;
}

// ===== OTP Verification =====

export interface VerifyOtpRequest {
    email: string;
    otp: string;
}

export interface VerifyOtpResponse {
    status: string;
    message?: string;
    accessToken?: string;
    refreshToken?: string;
    id?: string;
}

// ===== Forgot Password =====

export interface ForgotPasswordRequest {
    email: string;
}

export interface ForgotPasswordResponse {
    status: string;
    message?: string;
}

// ===== Reset Password =====

export interface ResetPasswordRequest {
    email: string;
    newPassword: string;
    reEnterPassword: string;
}

export interface ResetPasswordResponse {
    status: string;
    message?: string;
}

// ===== Google OAuth =====

export interface OAuth2GoogleRequest {
    idToken: string;
}

// ===== Logout =====

export interface LogoutRequest {
    token: string;
}

// ===== Refresh Token =====

export interface RefreshTokenRequest {
    refreshToken: string;
}

export interface RefreshTokenResponse {
    status: string;
    message?: string;
    accessToken: string;
}

// ===== Default Response (generic) =====

export interface DefaultResponse {
    status: string;
    message?: string;
    data?: any;
}
