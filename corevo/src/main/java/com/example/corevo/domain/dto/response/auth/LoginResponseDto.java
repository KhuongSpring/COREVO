package com.example.corevo.domain.dto.response.auth;

import com.example.corevo.constant.CommonConstant;
import com.example.corevo.domain.dto.response.CommonResponseDto;
import lombok.*;
import lombok.experimental.FieldDefaults;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.GrantedAuthority;

import java.util.Collection;

@NoArgsConstructor
@AllArgsConstructor
@Setter
@Getter
@FieldDefaults(level = AccessLevel.PRIVATE)
@Builder
public class LoginResponseDto extends CommonResponseDto {

    String tokenType = CommonConstant.BEARER_TOKEN;

    String accessToken;

    String refreshToken;

    String id;

    Boolean isDeleted;

    Boolean canRecovery;

    String messageResponse;

    long dayRecoveryRemaining;

    Collection<? extends GrantedAuthority> authorities;

    public LoginResponseDto(String accessToken, String refreshToken, String id, Collection<? extends GrantedAuthority> authorities) {
        this.accessToken = accessToken;
        this.refreshToken = refreshToken;
        this.id = id;
        this.authorities = authorities;
    }

    public LoginResponseDto(HttpStatus status, String message, String accessToken, Boolean isDeleted, Boolean canRecovery, long dayRecoveryRemaining) {
        super(status, message);
        this.accessToken = accessToken;
        this.isDeleted = isDeleted;
        this.canRecovery = canRecovery;
        this.dayRecoveryRemaining = dayRecoveryRemaining;
    }


}
