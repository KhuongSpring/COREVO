package com.example.corevo.controller;

import com.example.corevo.base.RestApiV1;
import com.example.corevo.base.VsResponseUtil;
import com.example.corevo.constant.UrlConstant;
import com.example.corevo.service.PolicyService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;

@RestApiV1
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
@Tag(name = "policy")
public class PolicyController {

    PolicyService policyService;

    @Operation(
            summary = "Lấy chính sách quyền riêng tư",
            description = "Lấy thông tin về chính sách và quyền riêng tư của app"
    )
    @GetMapping(UrlConstant.Policy.GET_PRIVACY_POLICY)
    public ResponseEntity<?> getPrivacyPolicy() {
        return VsResponseUtil.success(policyService.getPrivacyPolicy());
    }

    @Operation(
            summary = "Lấy điều khoản sử dụng",
            description = "Lấy thông tin về các điều khoản sử dụng của app"
    )
    @GetMapping(UrlConstant.Policy.GET_TERMS_OF_SERVICE)
    public ResponseEntity<?> getTermsOfService() {
        return VsResponseUtil.success(policyService.getTermsOfService());
    }
}
