package com.example.corevo.controller;

import com.example.corevo.base.RestApiV1;
import com.example.corevo.base.VsResponseUtil;
import com.example.corevo.constant.UrlConstant;
import com.example.corevo.domain.dto.request.user.health.UserHealthRequestDto;
import com.example.corevo.service.UserHealthService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import jakarta.validation.Valid;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

@RestApiV1
@RequiredArgsConstructor
@Validated
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class UserHealthController {

    UserHealthService userHealthService;

    @Operation(summary = "Điền thông tin sức khỏe cá nhân", description = "Dùng để người dùng điền thông tin sức khỏe cá nhân", security = @SecurityRequirement(name = "Bearer Token"))
    @PostMapping(UrlConstant.UserHealth.FILL_HEALTH_INFORMATION)
    public ResponseEntity<?> fillHealthInformation(
            Authentication authentication,
            @Valid @RequestBody UserHealthRequestDto request) {
        return VsResponseUtil.success(userHealthService.healthInformation(authentication, request));
    }
}
