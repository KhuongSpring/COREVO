import apiClient from '@/services/api/client';
import { ApiEndpoints } from '@/constants/ApiEndpoints';
import {
    LoginRequest,
    LoginResponse,
    RegisterRequest,
    RegisterResponse,
    VerifyOtpRequest,
    VerifyOtpResponse,
    ForgotPasswordRequest,
    ForgotPasswordResponse,
    ResetPasswordRequest,
    ResetPasswordResponse,
    OAuth2GoogleRequest,
    DefaultResponse,
} from '@/types/auth';
import { ApiResponse } from '@/types/common';
import { saveAccessToken, saveRefreshToken, getRefreshToken, clearTokens } from '@/services/storage';

/**
 * Authentication Service
 * All authentication-related API calls
 */

/**
 * Login with username and password
 */
export const login = async (request: LoginRequest): Promise<ApiResponse<LoginResponse>> => {
    const response = await apiClient.post<ApiResponse<LoginResponse>>(
        ApiEndpoints.auth.login,
        request
    );
    return response.data;
};

/**
 * Login with Google OAuth2
 */
export const loginWithGoogle = async (
    request: OAuth2GoogleRequest
): Promise<ApiResponse<LoginResponse>> => {
    const response = await apiClient.post<ApiResponse<LoginResponse>>(
        ApiEndpoints.auth.loginWithGoogle,
        request
    );
    return response.data;
};

/**
 * Register new user
 */
export const register = async (request: RegisterRequest): Promise<ApiResponse<RegisterResponse>> => {
    const response = await apiClient.post<ApiResponse<RegisterResponse>>(
        ApiEndpoints.auth.register,
        request
    );
    return response.data;
};

/**
 * Verify OTP for registration
 */
export const verifyOtpToRegister = async (
    request: VerifyOtpRequest
): Promise<ApiResponse<VerifyOtpResponse>> => {
    const response = await apiClient.post<ApiResponse<VerifyOtpResponse>>(
        ApiEndpoints.auth.verifyOtp,
        request
    );
    return response.data;
};

/**
 * Send email to forgot password
 */
export const sendEmailToForgotPassword = async (
    request: ForgotPasswordRequest
): Promise<ApiResponse<ForgotPasswordResponse>> => {
    const response = await apiClient.post<ApiResponse<ForgotPasswordResponse>>(
        ApiEndpoints.auth.forgotPassword,
        request
    );
    return response.data;
};

/**
 * Verify OTP for reset password
 */
export const verifyOtpToResetPassword = async (
    request: VerifyOtpRequest
): Promise<ApiResponse<VerifyOtpResponse>> => {
    const response = await apiClient.post<ApiResponse<VerifyOtpResponse>>(
        ApiEndpoints.auth.verifyOtpResetPassword,
        request
    );
    return response.data;
};

/**
 * Reset password
 */
export const resetPassword = async (
    request: ResetPasswordRequest
): Promise<ApiResponse<ResetPasswordResponse>> => {
    const response = await apiClient.post<ApiResponse<ResetPasswordResponse>>(
        ApiEndpoints.auth.resetPassword,
        request
    );
    return response.data;
};

/**
 * Logout user
 */
export const logout = async (token: string): Promise<ApiResponse<DefaultResponse>> => {
    const response = await apiClient.post<ApiResponse<DefaultResponse>>(
        ApiEndpoints.auth.logout,
        { token }
    );
    return response.data;
};

/**
 * Refresh access token
 */
export const refreshAccessToken = async (): Promise<string | null> => {
    const refreshToken = await getRefreshToken();

    if (!refreshToken) {
        return null;
    }

    try {
        const response = await apiClient.post(
            ApiEndpoints.auth.refreshToken,
            { refreshToken }
        );

        const newAccessToken = response.data.data.accessToken;

        if (newAccessToken) {
            await saveAccessToken(newAccessToken);
            return newAccessToken;
        } else {
            await clearTokens();
            return null;
        }
    } catch (error) {
        await clearTokens();
        return null;
    }
};

/**
 * Get privacy policy
 */
export const getPrivacy = async (): Promise<ApiResponse<DefaultResponse>> => {
    const response = await apiClient.get<ApiResponse<DefaultResponse>>(
        ApiEndpoints.policy.getPrivacy
    );
    return response.data;
};

/**
 * Get terms of service
 */
export const getTerms = async (): Promise<ApiResponse<DefaultResponse>> => {
    const response = await apiClient.get<ApiResponse<DefaultResponse>>(
        ApiEndpoints.policy.getTerms
    );
    return response.data;
};

/**
 * Send email to recover account
 */
export const sendEmailToRecoveryAccount = async (
    email: string
): Promise<ApiResponse<DefaultResponse>> => {
    const response = await apiClient.post<ApiResponse<DefaultResponse>>(
        ApiEndpoints.auth.accountRecovery,
        { email }
    );
    return response.data;
};

/**
 * Verify OTP to recover account
 */
export const verifyOtpToRecover = async (
    request: VerifyOtpRequest
): Promise<ApiResponse<VerifyOtpResponse>> => {
    const response = await apiClient.post<ApiResponse<VerifyOtpResponse>>(
        ApiEndpoints.auth.recoverAccount,
        request
    );
    return response.data;
};
