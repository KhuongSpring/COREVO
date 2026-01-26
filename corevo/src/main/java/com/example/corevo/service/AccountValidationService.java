package com.example.corevo.service;

import com.example.corevo.domain.dto.response.auth.LoginResponseDto;
import com.example.corevo.domain.entity.user.User;

public interface AccountValidationService {

    void validateAccountActive(User user);

    LoginResponseDto buildAccountStatusResponse(User user);

    boolean isAccountDeleted(User user);

    boolean isAccountLocked(User user);

    boolean canRecoverAccount(User user);

    long getDaysRemainingForRecovery(User user);
}
