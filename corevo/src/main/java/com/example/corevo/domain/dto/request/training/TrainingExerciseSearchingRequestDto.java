package com.example.corevo.domain.dto.request.training;

import com.example.corevo.constant.ErrorMessage;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import lombok.*;
import lombok.experimental.FieldDefaults;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class TrainingExerciseSearchingRequestDto {

    @Schema(description = "Loại tìm kiếm", example = "targetMuscle")
    String keyType;

    @Schema(description = "Câu yêu cầu tìm kiếm", example = "Chest")
    @NotBlank(message = ErrorMessage.NOT_BLANK_FIELD)
    String searchSentence;
}
