package com.example.corevo.domain.dto.request.user.health;

import com.example.corevo.constant.CommonConstant;
import com.example.corevo.constant.ErrorMessage;
import com.example.corevo.domain.entity.user.ActivityLevel;
import com.example.corevo.domain.entity.user.Gender;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
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
public class UpdateHealthRequestDto {

    @Schema(description = "Giới tính", example = "MALE")
    Gender gender;

    @Schema(description = "Chiều cao (cm)", example = "170")
    @Min(value = CommonConstant.MIN_HEIGHT, message = ErrorMessage.UserHealth.ERR_HEIGHT_MIN_VALUE)
    @Max(value = CommonConstant.MAX_HEIGHT, message = ErrorMessage.UserHealth.ERR_HEIGHT_MAX_VALUE)
    Integer height;

    @Schema(description = "Cân nặng (kg)", example = "60")
    @Min(value = CommonConstant.MIN_WEIGHT, message = ErrorMessage.UserHealth.ERR_WEIGHT_MIN_VALUE)
    @Max(value = CommonConstant.MAX_WEIGHT, message = ErrorMessage.UserHealth.ERR_WEIGHT_MAX_VALUE)
    Integer weight;

    @Schema(description = "Tuổi", example = "20")
    @Min(value = CommonConstant.MIN_AGE, message = ErrorMessage.UserHealth.ERR_AGE_MIN_VALUE)
    @Max(value = CommonConstant.MAX_AGE, message = ErrorMessage.UserHealth.ERR_AGE_MAX_VALUE)
    Integer age;

    @Schema(description = "Hệ số hoạt động")
    ActivityLevel activityLevel;
}
