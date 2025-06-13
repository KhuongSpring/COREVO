package com.example.corevo.domain.dto.request.user.enter_personal_infomation;

import com.example.corevo.constant.ErrorMessage;
import jakarta.validation.constraints.NotBlank;
import lombok.*;
import lombok.experimental.FieldDefaults;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@FieldDefaults(level = AccessLevel.PRIVATE)
public class AddressInformationRequestDto {

    @NotBlank(message = ErrorMessage.NOT_BLANK_FIELD)
    String province;

    @NotBlank(message = ErrorMessage.NOT_BLANK_FIELD)
    String district;

}
