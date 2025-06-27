package com.example.corevo.domain.dto.request.training;

import com.example.corevo.constant.ErrorMessage;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.util.List;
import java.util.Map;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class TrainingPlanFlowRequestDto {

    @Schema(description = "Tên của bước hiện tại trong workflow", example = "goals")
    @NotBlank(message = ErrorMessage.NOT_BLANK_FIELD)
    private String currentStep;

    @Schema(
            description = "Danh sách giá trị người dùng chọn ở bước hiện tại (thường 1 phần tử, nhưng có thể nhiều ở bước như equipment/location)",
            example = "[\"Gain weight\"]"
    )
    @NotNull(message = ErrorMessage.NOT_BLANK_FIELD)
    @Size(min = 1, message = ErrorMessage.NOT_BLANK_FIELD)
    private List<String> selectedValue;

    @Schema(
            description = "Lưu trữ toàn bộ các bước và giá trị mà người dùng đã chọn trước đó",
            example = """
        {
          "goals": ["Gain weight"],
          "level": ["BEGINNER"],
          "duration": ["30 phút"],
          "type": ["Gym"],
          "frequency": ["4 - 5 buối / tuần"],
          "location": ["HOME", "GYM"],
          "equipment": ["Gym equipment"]
        }
    """
    )
    private Map<String, List<String>> selectedValues;

}
