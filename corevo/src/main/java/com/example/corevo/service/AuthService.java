package com.example.corevo.service;

import com.example.corevo.domain.dto.request.LoginRequestDto;
import com.example.corevo.domain.dto.request.TokenRefreshRequestDto;
import com.example.corevo.domain.dto.request.UserCreateRequestDto;
import com.example.corevo.domain.dto.response.CommonResponseDto;
import com.example.corevo.domain.dto.response.LoginResponseDto;
import com.example.corevo.domain.dto.response.TokenRefreshResponseDto;
import com.example.corevo.domain.dto.response.user.UserResponseDto;
import jakarta.servlet.http.HttpServletRequest;

public interface AuthService {
    LoginResponseDto authentication(LoginRequestDto request);
    UserResponseDto register(UserCreateRequestDto request);
}
