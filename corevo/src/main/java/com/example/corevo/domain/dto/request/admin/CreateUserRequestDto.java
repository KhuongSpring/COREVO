package com.example.corevo.domain.dto.request.admin;

import com.example.corevo.constant.ErrorMessage;
import com.example.corevo.domain.entity.Role;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDate;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@FieldDefaults(level = AccessLevel.PRIVATE)
public class CreateUserRequestDto {

    @Schema(description = "Tên đăng nhập", example = "user123")
    @NotBlank(message = ErrorMessage.NOT_BLANK_FIELD)
    String username;

    @Schema(description = "Email người dùng", example = "user@gmail.com")
    @NotBlank(message = ErrorMessage.NOT_BLANK_FIELD)
    @Email(message = ErrorMessage.INVALID_SOME_THING_FIELD)
    String email;

    @Schema(description = "Mật khẩu", example = "User123@!#")
    @NotBlank(message = ErrorMessage.NOT_BLANK_FIELD)
    @Pattern(regexp = "^(?=.*[0-9])(?=.*[a-z])(?=\\S+$).{8,}$", message = ErrorMessage.INVALID_FORMAT_PASSWORD)
    String password;

    @Schema(description = "Họ/Tên đệm", example = "Phạm Minh")
    String firstName;

    @Schema(description = "Tên", example = "Khương")
    String lastName;

    @Schema(description = "Ngày sinh", example = "2000-01-15")
    LocalDate birth;

    @Schema(description = "Số điện thoại", example = "0123456789")
    String phone;
    
    @Schema(description = "Quốc tịch", example = "Việt Nam")
    String nationality;

    @Schema(description = "Vai trò", example = "USER")
    @NotNull(message = ErrorMessage.INVALID_SOME_THING_FIELD_IS_REQUIRED)
    Role role;
}
