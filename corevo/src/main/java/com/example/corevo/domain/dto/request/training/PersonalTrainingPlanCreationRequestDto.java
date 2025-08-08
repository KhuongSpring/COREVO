package com.example.corevo.domain.dto.request.training;

import com.example.corevo.constant.ErrorMessage;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.*;
import lombok.experimental.FieldDefaults;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class PersonalTrainingPlanCreationRequestDto {

    @NotBlank(message = ErrorMessage.NOT_BLANK_FIELD)
    String planName;

    String description;

    @NotNull(message = ErrorMessage.NOT_BLANK_FIELD)
    Long goalId;

    @NotNull(message = ErrorMessage.NOT_BLANK_FIELD)
    Long typeId;
}