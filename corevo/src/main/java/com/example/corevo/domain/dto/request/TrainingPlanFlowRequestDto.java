package com.example.corevo.domain.dto.request;

import com.example.corevo.constant.ErrorMessage;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.experimental.FieldDefaults;

import java.util.Map;

@Getter
@FieldDefaults(level = AccessLevel.PRIVATE)
public class TrainingPlanFlowRequestDto {

    @Schema(description = "Bước hiện tại", example = "goals")
    @NotBlank(message = ErrorMessage.NOT_BLANK_FIELD)
    String currentStep;

    @Schema(description = "Giá trị người dùng chọn", example = "Gain weight")
    @NotBlank(message = ErrorMessage.NOT_BLANK_FIELD)
    String selectedValue;

    @Schema(description = "Các bước người dùng đã chọn")
    Map<String, String> selectedValues;
}
