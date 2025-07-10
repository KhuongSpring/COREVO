package com.example.corevo.domain.dto.request.user.health;

import com.example.corevo.constant.ErrorMessage;
import com.example.corevo.domain.entity.user.ActivityLevel;
import com.example.corevo.domain.entity.user.Gender;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.experimental.FieldDefaults;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@FieldDefaults(level = AccessLevel.PRIVATE)
public class UserHealthRequestDto {

    @Schema(description = "Giới tính", example = "MALE")
    @NotNull(message = ErrorMessage.UserHealth.ERR_GENDER_REQUIRED)
    Gender gender;

    @Schema(description = "Chiều cao (cm)", example = "170")
    @Min(value = 50, message = ErrorMessage.UserHealth.ERR_HEIGHT_MIN_VALUE)
    int height;

    @Schema(description = "Cân nặng (kg)", example = "60")
    @Min(value = 20, message = ErrorMessage.UserHealth.ERR_WEIGHT_MIN_VALUE)
    int weight;

    @Schema(description = "Tuổi", example = "20")
    @Min(value = 10, message = ErrorMessage.UserHealth.ERR_AGE_MIN_VALUE)
    int age;

    @Schema(description = "Hệ số hoạt động")
    @NotNull(message = ErrorMessage.UserHealth.ERR_ACTIVITY_LEVEL_REQUIRED)
    ActivityLevel activityLevel;

}
