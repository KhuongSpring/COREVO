package com.example.corevo.service;

import com.example.corevo.domain.dto.request.user.health.UserHealthRequestDto;

public interface HealthCalculationService {

    double calculateBMR(UserHealthRequestDto request);

    int calculateMaximumHeartRate(UserHealthRequestDto request);
    
    double calculateTDEE(UserHealthRequestDto request);

}
