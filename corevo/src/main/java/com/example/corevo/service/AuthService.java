package com.example.corevo.service;

import com.example.corevo.domain.dto.request.auth.ForgotPasswordRequestDto;
import com.example.corevo.domain.dto.request.auth.LoginRequestDto;
import com.example.corevo.domain.dto.request.auth.RegisterRequestDto;
import com.example.corevo.domain.dto.request.auth.ResetPasswordRequestDto;
import com.example.corevo.domain.dto.request.auth.otp.VerifyOtpRequestDto;
import com.example.corevo.domain.dto.response.auth.LoginResponseDto;
import com.example.corevo.domain.dto.response.user.UserResponseDto;

public interface AuthService {
    LoginResponseDto authentication(LoginRequestDto request);
    void register(RegisterRequestDto request);
    UserResponseDto verifyOtpToRegister(VerifyOtpRequestDto request);
    void forgotPassword(ForgotPasswordRequestDto request);
    boolean verifyOtpToResetPassword(VerifyOtpRequestDto request);
    UserResponseDto resetPassword(ResetPasswordRequestDto request);

    String generateOtp();
}
