package com.example.corevo.service;

import com.example.corevo.domain.dto.request.auth.LoginRequestDto;
import com.example.corevo.domain.dto.request.auth.RegisterRequestDto;
import com.example.corevo.domain.dto.request.auth.otp.VerifyOtpRequest;
import com.example.corevo.domain.dto.response.auth.LoginResponseDto;
import com.example.corevo.domain.dto.response.user.UserResponseDto;

public interface AuthService {
    LoginResponseDto authentication(LoginRequestDto request);
    void register(RegisterRequestDto request);
    UserResponseDto verifyOtp(VerifyOtpRequest request);
    String generateOtp();
}
