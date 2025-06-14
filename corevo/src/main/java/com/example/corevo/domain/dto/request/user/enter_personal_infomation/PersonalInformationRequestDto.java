package com.example.corevo.domain.dto.request.user.enter_personal_infomation;

import com.example.corevo.constant.ErrorMessage;
import com.example.corevo.domain.entity.Address;
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

    @Schema(description = "Tên tài khoản", example = "khuong123")
    @NotBlank(message = ErrorMessage.NOT_BLANK_FIELD)
    String username;

    @Schema(description = "Số điện thoại", example = "0383329533")
    @NotBlank(message = ErrorMessage.NOT_BLANK_FIELD)
    String phone;

    @Schema(description = "Ngày tháng năm sinh", example = "2005-04-17")
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
