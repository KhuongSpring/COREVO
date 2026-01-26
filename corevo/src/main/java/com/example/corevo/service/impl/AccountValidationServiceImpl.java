package com.example.corevo.service.impl;

import com.example.corevo.constant.CommonConstant;
import com.example.corevo.constant.ErrorMessage;
import com.example.corevo.domain.dto.response.auth.LoginResponseDto;
import com.example.corevo.domain.entity.user.User;
import com.example.corevo.exception.VsException;
import com.example.corevo.service.AccountValidationService;
import com.example.corevo.utils.TimeUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

@Slf4j
@Service
@RequiredArgsConstructor
public class AccountValidationServiceImpl implements AccountValidationService {

    @Override
    public void validateAccountActive(User user) {
        if (Boolean.TRUE.equals(user.getIsDeleted())) {
            throw new VsException(HttpStatus.UNAUTHORIZED, ErrorMessage.Auth.ERR_LOGIN_FAIL);
        }

        if (Boolean.TRUE.equals(user.getIsLocked())) {
            throw new VsException(HttpStatus.UNAUTHORIZED, ErrorMessage.Auth.ERR_ACCOUNT_LOCKED);
        }
    }

    @Override
    public LoginResponseDto buildAccountStatusResponse(User user) {
        if (Boolean.TRUE.equals(user.getIsDeleted())) {
            return buildDeletedAccountResponse(user);
        }

        if (Boolean.TRUE.equals(user.getIsLocked())) {
            return buildLockedAccountResponse();
        }

        // Account is active - should not call this method in this case
        log.warn("buildAccountStatusResponse called for active account: {}", user.getId());
        return null;
    }

    @Override
    public boolean isAccountDeleted(User user) {
        return Boolean.TRUE.equals(user.getIsDeleted());
    }

    @Override
    public boolean isAccountLocked(User user) {
        return Boolean.TRUE.equals(user.getIsLocked());
    }

    @Override
    public boolean canRecoverAccount(User user) {
        if (!isAccountDeleted(user) || user.getDeletedAt() == null) {
            return false;
        }

        LocalDate expiredDate = user.getDeletedAt().plusDays(CommonConstant.ACCOUNT_RECOVERY_DAYS);
        return TimeUtil.today().isBefore(expiredDate);
    }

    @Override
    public long getDaysRemainingForRecovery(User user) {
        if (!isAccountDeleted(user) || user.getDeletedAt() == null) {
            return 0;
        }

        LocalDate expiredDate = user.getDeletedAt().plusDays(CommonConstant.ACCOUNT_RECOVERY_DAYS);
        LocalDate today = TimeUtil.today();

        if (today.isAfter(expiredDate)) {
            return 0;
        }

        return ChronoUnit.DAYS.between(today, expiredDate);
    }

    /**
     * Builds response for deleted account with recovery information
     */
    private LoginResponseDto buildDeletedAccountResponse(User user) {
        boolean canRecover = canRecoverAccount(user);
        long daysRemaining = getDaysRemainingForRecovery(user);

        return LoginResponseDto.builder()
                .status(HttpStatus.UNAUTHORIZED)
                .message(ErrorMessage.Auth.ERR_LOGIN_FAIL)
                .isDeleted(true)
                .canRecovery(canRecover)
                .dayRecoveryRemaining(daysRemaining)
                .build();
    }

    /**
     * Builds response for locked account
     */
    private LoginResponseDto buildLockedAccountResponse() {
        return LoginResponseDto.builder()
                .status(HttpStatus.UNAUTHORIZED)
                .message(ErrorMessage.Auth.ERR_ACCOUNT_LOCKED)
                .build();
    }
}
