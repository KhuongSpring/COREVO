package com.example.corevo.domain.dto.request.auth;

import com.example.corevo.constant.ErrorMessage;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import lombok.*;
import lombok.experimental.FieldDefaults;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@FieldDefaults(level = AccessLevel.PRIVATE)
public class LoginRequestDto {

    @Schema(description = "Tên đăng nhập", example = "khuong123")
    @NotBlank(message = ErrorMessage.NOT_BLANK_FIELD)
    String username;

    @Schema(description = "Mật khẩu", example = "Khuong123@")
    @NotBlank(message = ErrorMessage.NOT_BLANK_FIELD)
    String password;

}
