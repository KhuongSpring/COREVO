package com.example.corevo.domain.dto.response.training_plan;

import com.example.corevo.domain.dto.response.training_exercise.TrainingExerciseResponseDto;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDate;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class PersonalTrainingDayResponseDto {

    Long dayId;
    Long planId;
    Integer dayNumber;
    LocalDate actualDate;
    Boolean isRestDay;
    List<TrainingExerciseResponseDto> completedExercises;
}