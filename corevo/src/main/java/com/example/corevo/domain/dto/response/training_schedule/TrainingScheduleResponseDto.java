package com.example.corevo.domain.dto.response.training_schedule;

import lombok.*;
import lombok.experimental.FieldDefaults;

import java.util.List;

@AllArgsConstructor
@NoArgsConstructor
@Setter
@Getter
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class TrainingScheduleResponseDto {

    String userId;

    Long trainingPlanId;

    List<TrainingDayResponseDto> days;
}
