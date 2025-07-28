package com.example.corevo.domain.dto.response.training_schedule;

import lombok.*;
import lombok.experimental.FieldDefaults;

@AllArgsConstructor
@NoArgsConstructor
@Setter
@Getter
@FieldDefaults(level = AccessLevel.PRIVATE)
public class TrainingExerciseGroupDetailsResponseDto {

    Long exerciseId;

    String duration;
}
