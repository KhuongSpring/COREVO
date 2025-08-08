package com.example.corevo.domain.dto.response.training_plan;

import lombok.*;
import lombok.experimental.FieldDefaults;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class PersonalTrainingPlanResponseDto {

    Long planId;
    String planName;
    String description;
    String goalName;
    String typeName;
    String userId;
}