package com.example.corevo.domain.dto.response.training_progress;

import lombok.*;
import lombok.experimental.FieldDefaults;

@AllArgsConstructor
@NoArgsConstructor
@Setter
@Getter
@FieldDefaults(level = AccessLevel.PRIVATE)
public class WeeklyProgressResponseDto {

    Long trainingPlanId;

    Double weeklyPercentage;

    Integer completedDays;
}