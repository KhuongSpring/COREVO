package com.example.corevo.domain.dto.response.training_schedule;

import lombok.*;
import lombok.experimental.FieldDefaults;

@AllArgsConstructor
@NoArgsConstructor
@Setter
@Getter
@FieldDefaults(level = AccessLevel.PRIVATE)
public class TrainingDayResponseDto {

    Long id;

    String dayOfWeek;

    String name;

    String duration;

    String location;

    String description;

    TrainingExerciseGroupResponseDto exerciseGroups;
}
