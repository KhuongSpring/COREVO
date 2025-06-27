package com.example.corevo.domain.dto.response.training_exercise;

import com.example.corevo.domain.dto.response.training.LevelResponseDto;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.util.List;

@AllArgsConstructor
@NoArgsConstructor
@Setter
@Getter
@FieldDefaults(level = AccessLevel.PRIVATE)
public class TrainingExerciseLevelResponseDto {
    List<TrainingExerciseResponseDto> trainingExercises;
    LevelResponseDto level;
}
