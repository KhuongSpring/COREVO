package com.example.corevo.domain.dto.response;

import com.example.corevo.constant.CommonConstant;
import lombok.*;
import lombok.experimental.FieldDefaults;
import org.springframework.security.core.GrantedAuthority;

import java.util.Collection;

@NoArgsConstructor
@AllArgsConstructor
@Setter
@Getter
@FieldDefaults(level = AccessLevel.PRIVATE)
@Builder
public class LoginResponseDto {

    String tokenType = CommonConstant.BEARER_TOKEN;

    String accessToken;

    String refreshToken;

    String id;

    Collection<? extends GrantedAuthority> authorities;

    public LoginResponseDto(String accessToken, String refreshToken, String id, Collection<? extends GrantedAuthority> authorities) {
        this.accessToken = accessToken;
        this.refreshToken = refreshToken;
        this.id = id;
        this.authorities = authorities;
    }

}
