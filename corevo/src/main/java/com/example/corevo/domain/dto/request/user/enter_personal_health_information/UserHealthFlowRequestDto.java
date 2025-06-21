package com.example.corevo.domain.dto.request.user.enter_personal_health_information;

import com.example.corevo.constant.ErrorMessage;
import jakarta.validation.constraints.NotBlank;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.experimental.FieldDefaults;

@Getter
@FieldDefaults(level = AccessLevel.PRIVATE)
public class UserHealthFlowRequestDto {

    @NotBlank(message = ErrorMessage.NOT_BLANK_FIELD)
    String selectedValue;

}
