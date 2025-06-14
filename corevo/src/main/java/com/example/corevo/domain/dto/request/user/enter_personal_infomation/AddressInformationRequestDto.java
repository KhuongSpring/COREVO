package com.example.corevo.domain.dto.request.user.enter_personal_infomation;

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
public class AddressInformationRequestDto {

    @Schema(description = "Tỉnh thành", example = "Hà Nội")
    @NotBlank(message = ErrorMessage.NOT_BLANK_FIELD)
    String province;

    @Schema(description = "Quận/huyện", example = "Bắc Từ Liêm")
    @NotBlank(message = ErrorMessage.NOT_BLANK_FIELD)
    String district;

}
