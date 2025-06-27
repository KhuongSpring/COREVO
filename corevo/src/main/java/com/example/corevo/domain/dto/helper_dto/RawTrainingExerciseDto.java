package com.example.corevo.domain.dto.helper_dto;

import lombok.*;
import lombok.experimental.FieldDefaults;

import java.util.List;

@AllArgsConstructor
@NoArgsConstructor
@Setter
@Getter
@FieldDefaults(level = AccessLevel.PRIVATE)
public class RawTrainingExerciseDto {
    String name;
    String description;
    String sets;
    String reps;
    String duration;
    Media media;

    List<Long> levelIds;
    List<Long> typeIds;
    List<Long> primaryTargetMuscleIds;
    List<Long> secondaryTargetMuscleIds;
    List<Long> equipmentIds;
    List<Long> locationIds;
    List<Long> goalIds;

    @Data
    public static class Media {
        private String image;
        private String video;
    }
}
