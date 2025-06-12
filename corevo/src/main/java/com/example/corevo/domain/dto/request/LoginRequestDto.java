package com.example.corevo.domain.dto.request;

import com.example.corevo.constant.ErrorMessage;
import jakarta.validation.constraints.NotBlank;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.experimental.FieldDefaults;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@FieldDefaults(level = AccessLevel.PRIVATE)
public class LoginRequestDto {

    @NotBlank(message = ErrorMessage.NOT_BLANK_FIELD)
    String emailOrUsername;

    @NotBlank(message = ErrorMessage.NOT_BLANK_FIELD)
    String password;

}
