package com.example.corevo.domain.dto.request.admin;

import com.example.corevo.constant.ErrorMessage;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class CreateTrainingExerciseRequestDto {

    @Schema(description = "Tên bài tập", example = "Plank")
    @NotBlank(message = ErrorMessage.NOT_BLANK_FIELD)
    String name;

    @NotBlank(message = ErrorMessage.NOT_BLANK_FIELD)
    String imageURL;

    @Schema(description = "Mô tả bài tập", example = "Plank là bài giúp xây dựng sức bền cơ bụng...")
    @NotBlank(message = ErrorMessage.NOT_BLANK_FIELD)
    String description;

    @Schema(description = "minSet", example = "0")
    @NotNull(message = ErrorMessage.NOT_BLANK_FIELD)
    Integer minSet;

    @Schema(description = "maxSet", example = "0")
    @NotNull(message = ErrorMessage.NOT_BLANK_FIELD)
    Integer maxSet;

    @Schema(description = "minRep", example = "0")
    @NotNull(message = ErrorMessage.NOT_BLANK_FIELD)
    Integer minRep;

    @Schema(description = "maxRep", example = "0")
    @NotNull(message = ErrorMessage.NOT_BLANK_FIELD)
    Integer maxRep;

    @Schema(description = "minDuration", example = "0")
    @NotNull(message = ErrorMessage.NOT_BLANK_FIELD)
    Integer minDuration;

    @Schema(description = "maxDuration", example = "0")
    @NotNull(message = ErrorMessage.NOT_BLANK_FIELD)
    Integer maxDuration;

    @Schema(description = "LevelIds", example = "[1]")
    @NotNull(message = ErrorMessage.NOT_BLANK_FIELD)
    List<Long> levelIds;

    @Schema(description = "TypeIds" , example = "[1]")
    @NotNull(message = ErrorMessage.NOT_BLANK_FIELD)
    List<Long> typeIds;

    @Schema(description = "primaryMuscleIds", example = "[1]")
    @NotNull(message = ErrorMessage.NOT_BLANK_FIELD)
    List<Long> primaryMuscleIds;

    @Schema(description = "secondaryMuscleIds", example = "[1]")
    @NotNull(message = ErrorMessage.NOT_BLANK_FIELD)
    List<Long> secondaryMuscleIds;

    @Schema(description = "equipmentIds", example = "[1]")
    @NotNull(message = ErrorMessage.NOT_BLANK_FIELD)
    List<Long> equipmentIds;

    @Schema(description = "locationIds", example = "[1]")
    @NotNull(message = ErrorMessage.NOT_BLANK_FIELD)
    List<Long> locationIds;

    @Schema(description = "goalIds", example = "[1]")
    @NotNull(message = ErrorMessage.NOT_BLANK_FIELD)
    List<Long> goalIds;

}
