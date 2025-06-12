package com.example.corevo.controller;

import com.example.corevo.base.RestApiV1;
import com.example.corevo.base.VsResponseUtil;
import com.example.corevo.constant.UrlConstant;
import com.example.corevo.domain.dto.request.LoginRequestDto;
import com.example.corevo.domain.dto.request.UserCreateRequestDto;
import com.example.corevo.service.AuthService;
import jakarta.validation.Valid;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

@RestApiV1
@Validated
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class AuthController {
    AuthService authService;

    @PostMapping(UrlConstant.Auth.LOGIN)
    public ResponseEntity<?> login(@Valid @RequestBody LoginRequestDto requestDto){
        return VsResponseUtil.success(authService.authentication(requestDto));
    }

    @PostMapping(UrlConstant.Auth.REGISTER)
    public ResponseEntity<?> register(@Valid @RequestBody UserCreateRequestDto requestDto){
        return VsResponseUtil.success(authService.register(requestDto));
    }
}
