package com.example.corevo.service.impl;

import com.example.corevo.domain.dto.response.policy.PolicyResponseDto;
import com.example.corevo.service.PolicyService;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;

@Service
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
@Slf4j
public class PolicyServiceImpl implements PolicyService {

    @Override
    public PolicyResponseDto getPrivacyPolicy() {
        String content = readPolicyFile("policies/privacy-policy.txt");
        return new PolicyResponseDto("CHÍNH SÁCH QUYỀN RIÊNG TƯ", content, "09/07/2025");
    }

    @Override
    public PolicyResponseDto getTermsOfService() {
        String content = readPolicyFile("policies/terms-of-service.txt");
        return new PolicyResponseDto("ĐIỀU KHOẢN SỬ DỤNG", content, "09/07/2025");
    }

    private String readPolicyFile(String filePath) {
        try {
            ClassPathResource resource = new ClassPathResource(filePath);
            return Files.readString(Paths.get(resource.getURI()), StandardCharsets.UTF_8);
        } catch (IOException e) {
            log.error("Error reading policy file: {}", filePath, e);
            return "Nội dung chính sách đang được cập nhật. Vui lòng thử lại sau.";
        }
    }
}
