package com.example.corevo.service;

import com.example.corevo.domain.dto.request.user.health.UserHealthRequestDto;
import com.example.corevo.domain.dto.response.user.UserResponseDto;

public interface UserHealthService {
    UserResponseDto healthInformation(UserHealthRequestDto request);
}
