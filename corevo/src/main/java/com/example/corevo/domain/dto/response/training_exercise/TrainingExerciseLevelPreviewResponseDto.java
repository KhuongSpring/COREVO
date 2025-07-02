package com.example.corevo.domain.dto.response.training_exercise;

import lombok.*;
import lombok.experimental.FieldDefaults;

import java.util.List;

@AllArgsConstructor
@NoArgsConstructor
@Setter
@Getter
@FieldDefaults(level = AccessLevel.PRIVATE)
public class TrainingExerciseLevelPreviewResponseDto {

    String levelName;

    List<TrainingExercisePreviewResponseDto> exercises;

}
