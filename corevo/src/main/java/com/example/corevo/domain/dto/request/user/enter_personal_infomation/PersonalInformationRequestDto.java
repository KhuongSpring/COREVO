package com.example.corevo.domain.dto.request.user.enter_personal_infomation;

import com.example.corevo.constant.ErrorMessage;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDate;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@FieldDefaults(level = AccessLevel.PRIVATE)
public class PersonalInformationRequestDto {

    @Schema(description = "Tên tài khoản", example = "user123")
    @NotBlank(message = ErrorMessage.NOT_BLANK_FIELD)
    String username;

    @Schema(description = "Số điện thoại", example = "0123456789")
    @NotBlank(message = ErrorMessage.NOT_BLANK_FIELD)
    String phone;

    @Schema(description = "Ngày tháng năm sinh", example = "2000-01-01")
    @NotNull(message = ErrorMessage.NOT_BLANK_FIELD)
    LocalDate birth;

    @Schema(description = "Quốc tịch", example = "Việt Nam")
    @NotBlank(message = ErrorMessage.NOT_BLANK_FIELD)
    String nationality;

    @Schema(description = "Địa chỉ")
    @Valid
    @NotNull(message = ErrorMessage.NOT_BLANK_FIELD)
    AddressInformationRequestDto address;

}
