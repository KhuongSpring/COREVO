package com.example.corevo.service;

import com.example.corevo.domain.dto.response.TrainingPlanFlowResponseDto;

import java.util.Map;

public interface TrainingPlanFlowService {
    TrainingPlanFlowResponseDto processStep(String currentStep, String selectedValue, Map<String, String> selectedValues);
}
