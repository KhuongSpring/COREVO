package com.example.corevo.domain.dto.response;

import com.example.corevo.domain.dto.request.TrainingPlanFlowRequestDto;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.util.List;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@FieldDefaults(level = AccessLevel.PRIVATE)
public class TrainingPlanFlowResponseDto {
    String nextStep;
    List<Object> option;
    TrainingPlanResponseDto trainingPlanResponseDto;

    public TrainingPlanFlowResponseDto(String nextStep, List<Object> option) {
        this.nextStep = nextStep;
        this.option = option;
    }

    public TrainingPlanFlowResponseDto(TrainingPlanResponseDto trainingPlanResponseDto) {
        this.trainingPlanResponseDto = trainingPlanResponseDto;
    }
}
