package com.example.corevo.domain.dto.request.training;

import com.example.corevo.constant.ErrorMessage;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class TrainingDynamicSearchingRequestDto {

    @Schema(description = "Câu yêu cầu tìm kiếm", example = "Gym")
    @NotBlank(message = ErrorMessage.NOT_BLANK_FIELD)
    String searchSentence;

    @Schema(description = "Mức độ luyện tập tìm kiếm", example = "[1]")
    List<Long> levels;

    @Schema(description = "Địa điểm luyện tập tìm kiếm", example = "[2]")
    List<Long> locations;

    @Schema(description = "Dụng cụ luyện tập tìm kiếm", example = "[5]")
    List<Long> equipments;

    @Schema(description = "Mục tiêu luyện tập tìm kiếm", example = "Lose fat")
    String goal;

}
