package com.example.corevo.helper;

import com.example.corevo.domain.dto.helper_dto.RawTrainingExerciseDto;
import com.example.corevo.domain.dto.response.training.TrainingExerciseResponseDto;

import java.util.Optional;

public class TrainingExerciseConverter {
    public static TrainingExerciseResponseDto convert(RawTrainingExerciseDto raw) {
        TrainingExerciseResponseDto dto = new TrainingExerciseResponseDto();

        dto.setName(raw.getName());
        dto.setDescription(raw.getDescription());
        dto.setImageURL(raw.getMedia() != null ? raw.getMedia().getImage() : null);

        parseRange(raw.getSets()).ifPresent(pair -> {
            dto.setMinSet(pair[0]);
            dto.setMaxSet(pair[1]);
        });

        parseRange(raw.getReps()).ifPresent(pair -> {
            dto.setMinRep(pair[0]);
            dto.setMaxRep(pair[1]);
        });

        parseRange(raw.getDuration()).ifPresent(pair -> {
            dto.setMinDuration(pair[0]);
            dto.setMaxDuration(pair[1]);
        });

        dto.setLevelIds(raw.getLevelIds());
        dto.setTypeIds(raw.getTypeIds());
        dto.setPrimaryMuscleIds(raw.getPrimaryTargetMuscleIds());
        dto.setSecondaryMuscleIds(raw.getSecondaryTargetMuscleIds());
        dto.setEquipmentIds(raw.getEquipmentIds());
        dto.setLocationIds(raw.getLocationIds());
        dto.setGoalIds(raw.getGoalIds());

        return dto;
    }

    private static Optional<Integer[]> parseRange(String input) {
        if (input == null || input.isBlank()) return Optional.empty();
        String[] parts = input.split(",");
        if (parts.length == 2) {
            try {
                int min = Integer.parseInt(parts[0].trim());
                int max = Integer.parseInt(parts[1].trim());
                return Optional.of(new Integer[]{min, max});
            } catch (NumberFormatException e) {
                return Optional.empty();
            }
        }
        return Optional.empty();
    }
}
