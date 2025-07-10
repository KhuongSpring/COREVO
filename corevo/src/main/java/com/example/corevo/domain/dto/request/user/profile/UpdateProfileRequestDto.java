package com.example.corevo.domain.dto.request.user.profile;

import com.example.corevo.domain.dto.request.user.enter_personal_infomation.UpdatePersonalInformationRequestDto;
import com.example.corevo.domain.dto.request.user.health.UpdateHealthRequestDto;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.Valid;
import lombok.*;
import lombok.experimental.FieldDefaults;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@FieldDefaults(level = AccessLevel.PRIVATE)
public class UpdateProfileRequestDto {

    @Schema(description = "Thông tin cá nhân (bao gồm thông tin địa chỉ)")
    @Valid
    UpdatePersonalInformationRequestDto personalInformation;

    @Schema(description = "Thông tin sức khỏe")
    @Valid
    UpdateHealthRequestDto health;
}
