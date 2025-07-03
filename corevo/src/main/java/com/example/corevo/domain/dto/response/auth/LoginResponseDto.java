package com.example.corevo.domain.dto.response.auth;

import com.example.corevo.constant.CommonConstant;
import com.example.corevo.domain.dto.response.CommonResponseDto;
import lombok.*;
import lombok.experimental.FieldDefaults;
import org.springframework.http.HttpStatus;

@NoArgsConstructor
@AllArgsConstructor
@Setter
@Getter
@FieldDefaults(level = AccessLevel.PRIVATE)
@Builder
public class LoginResponseDto extends CommonResponseDto {

    String messageResponse;

    String accessToken;

    String id;

    Boolean isDeleted;

    Boolean canRecovery;

    long dayRecoveryRemaining;

    String tokenType = CommonConstant.BEARER_TOKEN;

    String refreshToken;

    public LoginResponseDto(HttpStatus status, String message, String accessToken, Boolean isDeleted, Boolean canRecovery, long dayRecoveryRemaining) {
        super(status, message);
        this.accessToken = accessToken;
        this.isDeleted = isDeleted;
        this.canRecovery = canRecovery;
        this.dayRecoveryRemaining = dayRecoveryRemaining;
    }


}
