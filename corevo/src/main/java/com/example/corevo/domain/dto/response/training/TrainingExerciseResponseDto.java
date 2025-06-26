package com.example.corevo.domain.dto.response.training;

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
        String imageURL;
        String description;
        Integer minSet;
        Integer maxSet;
        Integer minRep;
        Integer maxRep;
        Integer minDuration;
        Integer maxDuration;

        List<Long> levelIds;
        List<Long> typeIds;
        List<Long> primaryMuscleIds;
        List<Long> secondaryMuscleIds;
        List<Long> equipmentIds;
        List<Long> locationIds;
        List<Long> goalIds;
    }
