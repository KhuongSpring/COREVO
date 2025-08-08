package com.example.corevo.domain.dto.request.user.sreach;

import com.example.corevo.constant.ErrorMessage;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import lombok.*;
import lombok.experimental.FieldDefaults;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)

public class UserSearchingRequestDto {

    @Schema(description = "Tìm kiếm user", example = "Nhập")
    @NotBlank(message = ErrorMessage.NOT_BLANK_FIELD)
    String searchSentence;

}
