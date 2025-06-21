package com.example.corevo.domain.dto.response;

import com.example.corevo.domain.dto.request.TrainingPlanFlowRequestDto;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.util.List;
import java.util.Map;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@FieldDefaults(level = AccessLevel.PRIVATE)
public class TrainingPlanFlowResponseDto {
    String nextStep;
    boolean isFinalStep;
    Map<String, List<String>> selectedValues;
    List<TrainingPlanResponseDto> trainingPlans;
    List<Object> options;

    public TrainingPlanFlowResponseDto(String nextStep, List<Object> options) {
        this.nextStep = nextStep;
        this.options = options;
        this.isFinalStep = false;
    }

    public TrainingPlanFlowResponseDto(TrainingPlanResponseDto dto) {
        this.trainingPlans = List.of(dto);
        this.isFinalStep = true;
    }
}
