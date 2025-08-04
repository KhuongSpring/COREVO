package com.example.corevo.domain.dto.request.training;

import com.example.corevo.constant.ErrorMessage;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotNull;
import lombok.*;
import lombok.experimental.FieldDefaults;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class ExerciseCompletionRequestDto {

    @Schema(description = "ID của exercise", example = "104")
    @NotNull(message = ErrorMessage.NOT_BLANK_FIELD)
    Long exerciseId;

}