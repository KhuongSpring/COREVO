package com.example.corevo.domain.dto.request.auth.otp;

import com.example.corevo.constant.ErrorMessage;
import jakarta.validation.constraints.NotBlank;
import lombok.*;
import lombok.experimental.FieldDefaults;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@FieldDefaults(level = AccessLevel.PRIVATE)
public class VerifyOtpRequest {

    @NotBlank(message = ErrorMessage.NOT_BLANK_FIELD)
    String email;

    @NotBlank(message = ErrorMessage.NOT_BLANK_FIELD)
    String otp;
}
