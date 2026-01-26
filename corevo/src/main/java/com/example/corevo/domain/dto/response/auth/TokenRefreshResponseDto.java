package com.example.corevo.domain.dto.response.auth;

import com.example.corevo.constant.CommonConstant;
import lombok.*;
import lombok.experimental.FieldDefaults;

@NoArgsConstructor
@AllArgsConstructor
@Setter
@Getter
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class TokenRefreshResponseDto {

    @Builder.Default
    String tokenType = CommonConstant.BEARER_TOKEN;

    String accessToken;

    String refreshToken;

}
