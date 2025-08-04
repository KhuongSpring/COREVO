package com.example.corevo.domain.dto.response.training_progress;

import com.example.corevo.domain.entity.training.training_schedule_details.DayOfWeek;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.util.Map;

@AllArgsConstructor
@NoArgsConstructor
@Setter
@Getter
@FieldDefaults(level = AccessLevel.PRIVATE)
public class DailyProgressResponseDto {

    Long trainingPlanId;

    String day;

    Map<String, Boolean> completions;

    Double percentage;

}
