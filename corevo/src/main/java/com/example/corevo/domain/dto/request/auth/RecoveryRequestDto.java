package com.example.corevo.domain.dto.request.auth;

import com.example.corevo.constant.ErrorMessage;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.*;
import lombok.experimental.FieldDefaults;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@FieldDefaults(level = AccessLevel.PRIVATE)
public class RecoveryRequestDto {
    @Schema(description = "Email người dùng", example = "user@gmail.com")
    @Email
    @NotBlank(message = ErrorMessage.NOT_BLANK_FIELD)
    String email;
}
