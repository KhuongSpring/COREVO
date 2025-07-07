package com.example.corevo.domain.dto.request.user.enter_personal_infomation;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.*;
import lombok.experimental.FieldDefaults;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@FieldDefaults(level = AccessLevel.PRIVATE)
public class UpdateAddressRequestDto {

    @Schema(description = "Tỉnh thành", example = "Hà Nội")
    String province;

    @Schema(description = "Quận/huyện", example = "Bắc Từ Liêm")
    String district;
}
