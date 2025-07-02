package com.example.corevo.domain.dto.response.training_exercise;

import lombok.*;
import lombok.experimental.FieldDefaults;

import java.util.List;

@AllArgsConstructor
@NoArgsConstructor
@Setter
@Getter
@FieldDefaults(level = AccessLevel.PRIVATE)
public class TrainingExerciseResponseDto {

    String name;

    List<Long> levelIds;

    List<Long> typeIds;

    List<Long> primaryMuscleIds;

    List<Long> secondaryMuscleIds;

    List<Long> equipmentIds;

    List<Long> locationIds;

    Integer minSet;

    Integer maxSet;

    Integer minRep;

    Integer maxRep;

    Integer minDuration;

    Integer maxDuration;

    List<Long> goalIds;

    String imageURL;

    String description;

}
