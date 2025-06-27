package com.example.corevo.domain.dto.response.training_exercise;

import lombok.*;
import lombok.experimental.FieldDefaults;

import java.util.List;

@AllArgsConstructor
@NoArgsConstructor
@Setter
@Getter
@FieldDefaults(level = AccessLevel.PRIVATE)
@Builder
public class TrainingExerciseSearchResultResponseDto<T> {
    List<T> keyList;
    List<TrainingExerciseLevelResponseDto> results;

    public TrainingExerciseSearchResultResponseDto(List<T> keyList) {
        this.keyList = keyList;
    }
}
