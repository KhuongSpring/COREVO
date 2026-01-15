package com.example.corevo.service.impl;

import com.example.corevo.constant.CommonConstant;
import com.example.corevo.domain.dto.request.auth.otp.OtpType;
import com.example.corevo.service.OtpService;
import com.example.corevo.utils.TimeUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Map;
import java.util.Random;
import java.util.concurrent.ConcurrentHashMap;

/**
 * TODO: Replace with Redis cache for production to handle distributed systems
 * and automatic expiration
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class OtpServiceImpl implements OtpService {

    // Map structure: email -> OtpType -> OtpData
    private final Map<String, Map<OtpType, OtpData>> otpStore = new ConcurrentHashMap<>();

    @Override
    public String generateOtp() {
        Random random = new Random();
        int otp = CommonConstant.OTP_MIN_VALUE + random.nextInt(
                CommonConstant.OTP_MAX_VALUE - CommonConstant.OTP_MIN_VALUE);
        return String.valueOf(otp);
    }

    @Override
    public void storeOtp(String email, String otp, OtpType type, String dataJson) {
        LocalDateTime expiresAt = TimeUtil.plusMinutes(CommonConstant.OTP_EXPIRATION_MINUTES);

        OtpData otpData = new OtpData(otp, dataJson, expiresAt);

        otpStore.computeIfAbsent(email, k -> new ConcurrentHashMap<>())
                .put(type, otpData);

        log.debug("OTP stored for email: {}, type: {}, expires at: {}", email, type, expiresAt);
    }

    @Override
    public boolean validateOtp(String email, String otp, OtpType type) {
        Map<OtpType, OtpData> userOtps = otpStore.get(email);

        if (userOtps == null) {
            log.debug("No OTP found for email: {}", email);
            return false;
        }

        OtpData otpData = userOtps.get(type);

        if (otpData == null) {
            log.debug("No OTP found for email: {}, type: {}", email, type);
            return false;
        }

        if (otpData.isExpired()) {
            log.debug("OTP expired for email: {}, type: {}", email, type);
            clearOtp(email, type);
            return false;
        }

        boolean isValid = otp.equals(otpData.getOtp());
        log.debug("OTP validation result for email: {}, type: {}: {}", email, type, isValid);

        return isValid;
    }

    @Override
    public String getOtpData(String email, OtpType type) {
        Map<OtpType, OtpData> userOtps = otpStore.get(email);

        if (userOtps == null) {
            return null;
        }

        OtpData otpData = userOtps.get(type);

        if (otpData == null || otpData.isExpired()) {
            return null;
        }

        return otpData.getData();
    }

    @Override
    public void clearOtp(String email, OtpType type) {
        Map<OtpType, OtpData> userOtps = otpStore.get(email);

        if (userOtps != null) {
            userOtps.remove(type);

            // Remove email key if no more OTPs exist
            if (userOtps.isEmpty()) {
                otpStore.remove(email);
            }

            log.debug("OTP cleared for email: {}, type: {}", email, type);
        }
    }

    @Override
    public boolean isOtpValid(String email, OtpType type) {
        Map<OtpType, OtpData> userOtps = otpStore.get(email);

        if (userOtps == null) {
            return false;
        }

        OtpData otpData = userOtps.get(type);

        return otpData != null && !otpData.isExpired();
    }

    /**
     * Inner class to store OTP data with expiration
     */
    private static class OtpData {
        private final String otp;
        private final String data;
        private final LocalDateTime expiresAt;

        public OtpData(String otp, String data, LocalDateTime expiresAt) {
            this.otp = otp;
            this.data = data;
            this.expiresAt = expiresAt;
        }

        public String getOtp() {
            return otp;
        }

        public String getData() {
            return data;
        }

        public boolean isExpired() {
            return TimeUtil.now().isAfter(expiresAt);
        }
    }
}
