package com.example.corevo.controller;

import com.example.corevo.base.RestApiV1;
import com.example.corevo.base.VsResponseUtil;
import com.example.corevo.constant.SuccessMessage;
import com.example.corevo.constant.UrlConstant;
import com.example.corevo.domain.dto.request.auth.ForgotPasswordRequestDto;
import com.example.corevo.domain.dto.request.auth.LoginRequestDto;
import com.example.corevo.domain.dto.request.auth.RegisterRequestDto;
import com.example.corevo.domain.dto.request.auth.ResetPasswordRequestDto;
import com.example.corevo.domain.dto.request.auth.otp.VerifyOtpRequestDto;
import com.example.corevo.service.AuthService;
import io.swagger.v3.oas.annotations.Operation;
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

    @Operation(
            summary = "Đăng nhập tài khoản",
            description = "Dùng để đăng nhập tài khoản"
    )
    @PostMapping(UrlConstant.Auth.LOGIN)
    public ResponseEntity<?> login(@Valid @RequestBody LoginRequestDto requestDto){
        return VsResponseUtil.success(authService.authentication(requestDto));
    }

    @Operation(
            summary = "Đăng kí tài khoản",
            description = "Dùng để đăng kí tài khoản"
    )
    @PostMapping(UrlConstant.Auth.REGISTER)
    public ResponseEntity<?> register(@Valid @RequestBody RegisterRequestDto requestDto){
        authService.register(requestDto);
        return VsResponseUtil.success(SuccessMessage.Auth.SUCCESS_SEND_OTP);
    }

    @Operation(
            summary = "Xác thực OTP",
            description = "Dùng để xác thực OTP sau khi yêu cầu đăng kí tài khoản"
    )
    @PostMapping(UrlConstant.Auth.VERIFY_OTP)
    public ResponseEntity<?> verify(@Valid @RequestBody VerifyOtpRequestDto request){
        return VsResponseUtil.success(authService.verifyOtpToRegister(request));
    }

    @Operation(
            summary = "Quên mật khẩu",
            description = "Dùng để lấy lại mật khẩu"
    )
    @PostMapping(UrlConstant.Auth.FORGOT_PASSWORD)
    public ResponseEntity<?> forgotPassword(@Valid @RequestBody ForgotPasswordRequestDto request){
        authService.forgotPassword(request);
        return VsResponseUtil.success(SuccessMessage.Auth.SUCCESS_SEND_OTP);
    }

    @Operation(
            summary = "Xác thực OTP",
            description = "Dùng để xác thực OTP sau khi yêu cầu lấy lại mật khẩu"
    )
    @PostMapping(UrlConstant.Auth.VERIFY_OTP_TO_RESET_PASSWORD)
    public ResponseEntity<?> verifyToResetPassword(@Valid @RequestBody VerifyOtpRequestDto request){
        return VsResponseUtil.success(authService.verifyOtpToResetPassword(request));
    }

    @Operation(
            summary = "Đặt lại mật khẩu",
            description = "Dùng để đặt lại mật khẩu sau khi đã nhập được OTP"
    )
    @PostMapping(UrlConstant.Auth.RESET_PASSWORD)
    public ResponseEntity<?> resetPassword(@Valid @RequestBody ResetPasswordRequestDto request){
        return VsResponseUtil.success(authService.resetPassword(request));
    }
}
