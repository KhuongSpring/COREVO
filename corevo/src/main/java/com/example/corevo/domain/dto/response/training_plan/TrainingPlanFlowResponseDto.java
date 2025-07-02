package com.example.corevo.domain.dto.response.training_plan;

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

}
