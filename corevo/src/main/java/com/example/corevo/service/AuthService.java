package com.example.corevo.service;

import com.example.corevo.domain.dto.request.auth.*;
import com.example.corevo.domain.dto.request.auth.otp.VerifyOtpRequestDto;
import com.example.corevo.domain.dto.response.CommonResponseDto;
import com.example.corevo.domain.dto.response.auth.LoginResponseDto;
import com.example.corevo.domain.dto.response.auth.TokenRefreshResponseDto;
import com.example.corevo.domain.dto.response.user.UserResponseDto;

public interface AuthService {

    LoginResponseDto authentication(LoginRequestDto request);

    LoginResponseDto loginWithGoogle(OAuth2GoogleRequestDto request);

    CommonResponseDto logout(LogoutRequestDto request);

    TokenRefreshResponseDto refresh(TokenRefreshRequestDto request);

    CommonResponseDto register(RegisterRequestDto request);

    UserResponseDto verifyOtpToRegister(VerifyOtpRequestDto request);

    CommonResponseDto forgotPassword(ForgotPasswordRequestDto request);

    CommonResponseDto verifyOtpToResetPassword(VerifyOtpRequestDto request);

    UserResponseDto resetPassword(ResetPasswordRequestDto request);

    CommonResponseDto sendEmailRecoveryOtp(RecoveryRequestDto request);

    CommonResponseDto verifyOtpToRecovery(VerifyOtpRequestDto request);

    CommonResponseDto recoverAccount(VerifyOtpRequestDto request);
}
