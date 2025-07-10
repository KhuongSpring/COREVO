package com.example.corevo.service;

import com.example.corevo.domain.dto.request.user.health.UserHealthRequestDto;
import com.example.corevo.domain.dto.response.user.UserResponseDto;
import org.springframework.security.core.Authentication;

public interface UserHealthService {

    UserResponseDto healthInformation(Authentication authentication, UserHealthRequestDto request);

}
