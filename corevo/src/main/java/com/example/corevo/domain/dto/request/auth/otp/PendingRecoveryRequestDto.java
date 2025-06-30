package com.example.corevo.domain.dto.request.auth.otp;

import com.example.corevo.domain.dto.request.auth.RecoveryRequestDto;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDateTime;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@FieldDefaults(level = AccessLevel.PRIVATE)
public class PendingRecoveryRequestDto {
    RecoveryRequestDto request;
    String otp;
    LocalDateTime expireAt;

    public boolean isExpired() {
        return LocalDateTime.now().isAfter(expireAt);
    }
}
