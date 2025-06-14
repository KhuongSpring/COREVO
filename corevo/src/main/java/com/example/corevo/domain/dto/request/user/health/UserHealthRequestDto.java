package com.example.corevo.domain.dto.request.user.health;

import com.example.corevo.constant.ErrorMessage;
import com.example.corevo.domain.entity.ActivityLevel;
import com.example.corevo.domain.entity.Gender;

import jakarta.validation.constraints.Min;
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

    @NotNull(message = ErrorMessage.UserHealth.ERR_GENDER_REQUIRED)
    Gender gender;

    @Min(value = 50, message = ErrorMessage.UserHealth.ERR_HEIGHT_MIN_VALUE)
    int height;

    @Min(value = 20, message = ErrorMessage.UserHealth.ERR_WEIGHT_MIN_VALUE)
    int weight;

    @Min(value = 10, message = ErrorMessage.UserHealth.ERR_AGE_MIN_VALUE)
    int age;

    @NotNull(message = ErrorMessage.UserHealth.ERR_ACTIVITY_LEVEL_REQUIRED)
    ActivityLevel activityLevel;

}
