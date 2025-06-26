package com.example.corevo.domain.dto.request.admin;

import java.time.LocalDate;

import com.example.corevo.domain.entity.user.Role;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.experimental.FieldDefaults;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@FieldDefaults(level = AccessLevel.PRIVATE)
public class UpdateUserRequestDto {

    @Schema(description = "Tên đăng nhập", example = "user123")
    String username;

    @Schema(description = "Email người dùng", example = "user@gmail.com")
    String email;

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
    Role role;
    Boolean isActive;
}
