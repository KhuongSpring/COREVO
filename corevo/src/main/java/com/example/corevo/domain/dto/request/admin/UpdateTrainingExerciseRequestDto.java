package com.example.corevo.domain.dto.request.admin;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.util.List;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class UpdateTrainingExerciseRequestDto {

    @Schema(description = "Tên bài tập", example = "Plank")
    String name;

    @Schema(description = "URL ảnh", example = "string")
    String imageURL;

    @Schema(description = "Mô tả bài tập", example = "Plank là bài giúp xây dựng sức bền cơ bụng...")
    String description;

    @Schema(description = "minSet", example = "0")
    Integer minSet;

    @Schema(description = "maxSet", example = "0")
    Integer maxSet;

    @Schema(description = "minRep", example = "0")
    Integer minRep;

    @Schema(description = "maxRep", example = "0")
    Integer maxRep;

    @Schema(description = "minDuration", example = "0")
    Integer minDuration;

    @Schema(description = "maxDuration", example = "0")
    Integer maxDuration;

    @Schema(description = "LevelIds", example = "[1]")
    List<Long> levelIds;

    @Schema(description = "TypeIds", example = "[1]")
    List<Long> typeIds;

    @Schema(description = "primaryMuscleIds", example = "[1]")
    List<Long> primaryMuscleIds;

    @Schema(description = "secondaryMuscleIds", example = "[1]")
    List<Long> secondaryMuscleIds;

    @Schema(description = "equipmentIds", example = "[1]")
    List<Long> equipmentIds;

    @Schema(description = "locationIds", example = "[1]")
    List<Long> locationIds;

    @Schema(description = "goalIds", example = "[1]")
    List<Long> goalIds;

}
