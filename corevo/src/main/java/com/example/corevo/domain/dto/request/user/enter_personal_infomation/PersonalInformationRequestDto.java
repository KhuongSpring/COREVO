package com.example.corevo.domain.dto.request.user.enter_personal_infomation;

import com.example.corevo.constant.ErrorMessage;
import com.example.corevo.domain.entity.Address;
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

    @NotBlank(message = ErrorMessage.NOT_BLANK_FIELD)
    String username;

    @NotBlank(message = ErrorMessage.NOT_BLANK_FIELD)
    String phone;

    @NotNull(message = ErrorMessage.NOT_BLANK_FIELD)
    LocalDate birth;

    @NotBlank(message = ErrorMessage.NOT_BLANK_FIELD)
    String nationality;

    @Valid
    @NotNull(message = ErrorMessage.NOT_BLANK_FIELD)
    AddressInformationRequestDto address;

}
