package com.example.corevo.domain.dto.request.auth;

import com.example.corevo.constant.ErrorMessage;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import lombok.*;
import lombok.experimental.FieldDefaults;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@FieldDefaults(level = AccessLevel.PRIVATE)
public class RegisterRequestDto {

    @Schema(description = "Tên tài khoản", example = "khuong123")
    @NotNull(message = ErrorMessage.INVALID_SOME_THING_FIELD_IS_REQUIRED)
    String username;

    @Schema(description = "Mật khẩu", example = "Khuong123@")
    @NotNull(message = ErrorMessage.INVALID_SOME_THING_FIELD_IS_REQUIRED)
    @Pattern(regexp = "^(?=.*[0-9])(?=.*[a-z])(?=\\S+$).{8,}$", message = ErrorMessage.INVALID_FORMAT_PASSWORD)
    String password;

    @Schema(description = "Họ/Tên đệm", example = "Phạm Minh")
    @NotBlank(message = ErrorMessage.NOT_BLANK_FIELD)
    String firstName;

    @Schema(description = "Tên", example = "Khương")
    @NotBlank(message = ErrorMessage.NOT_BLANK_FIELD)
    String lastName;

    @Schema(description = "Email người dùng", example = "admin@gmail.com")
    @Email
    String email;
}
