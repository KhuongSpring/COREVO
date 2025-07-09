package com.example.corevo.service;

import com.example.corevo.domain.dto.response.policy.PolicyResponseDto;

public interface PolicyService {
    PolicyResponseDto getPrivacyPolicy();

    PolicyResponseDto getTermsOfService();
}
