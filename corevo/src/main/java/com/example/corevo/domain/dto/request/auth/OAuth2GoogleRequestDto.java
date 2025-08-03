package com.example.corevo.domain.dto.request.auth;

import lombok.*;
import lombok.experimental.FieldDefaults;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@FieldDefaults(level = AccessLevel.PRIVATE)
public class OAuth2GoogleRequestDto {

    String idToken;
}
