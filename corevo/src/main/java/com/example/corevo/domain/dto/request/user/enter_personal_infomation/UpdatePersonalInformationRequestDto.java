package com.example.corevo.domain.dto.request.user.enter_personal_infomation;

import java.time.LocalDate;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.Valid;
import lombok.*;
import lombok.experimental.FieldDefaults;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@FieldDefaults(level = AccessLevel.PRIVATE)
public class UpdatePersonalInformationRequestDto {

    @Schema(description = "Họ", example = "Nguyễn")
    String firstName;

    @Schema(description = "Tên", example = "Văn A")
    String lastName;

    @Schema(description = "Số điện thoại", example = "0123456789")
    String phone;

    @Schema(description = "Ngày tháng năm sinh", example = "2000-01-01")
    LocalDate birth;

    @Schema(description = "Quốc tịch", example = "Việt Nam")
    String nationality;

    @Schema(description = "Địa chỉ")
    @Valid
    UpdateAddressRequestDto address;
}
