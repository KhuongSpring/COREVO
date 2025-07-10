package com.example.corevo.service;

import com.example.corevo.domain.dto.response.CommonResponseDto;
import com.example.corevo.domain.dto.response.training_plan.TrainingPlanFlowResponseDto;
import org.springframework.security.core.Authentication;

import java.util.List;
import java.util.Map;

public interface TrainingPlanFlowService {

    TrainingPlanFlowResponseDto processStep(
            String currentStep,
            List<String> selectedValue,
            Map<String, List<String>> selectedValues);

    CommonResponseDto resetTrainingPlan(Authentication authentication);


}
