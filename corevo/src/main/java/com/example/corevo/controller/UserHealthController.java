package com.example.corevo.controller;


import com.example.corevo.base.RestApiV1;
import com.example.corevo.base.VsResponseUtil;
import com.example.corevo.constant.UrlConstant;
import com.example.corevo.domain.dto.request.user.enter_personal_infomation.PersonalInformationRequestDto;
import com.example.corevo.domain.dto.request.user.health.UserHealthRequestDto;
import com.example.corevo.domain.dto.response.user.health.UserHealthResponseDto;
import com.example.corevo.service.UserHealthService;
import com.example.corevo.service.UserService;
import jakarta.validation.Valid;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

@RestApiV1
@RequiredArgsConstructor
@Validated
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class UserHealthController {

    private final UserHealthService userHealthService;

    @PostMapping(UrlConstant.UserHealth.FILL_HEALTH_ÌNORMATION)
    public ResponseEntity<?> fillHealthInformation(@Valid @RequestBody UserHealthRequestDto request) {
        return VsResponseUtil.success(userHealthService.healthInformation(request));
    }
}
