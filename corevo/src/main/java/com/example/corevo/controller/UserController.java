package com.example.corevo.controller;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import com.example.corevo.base.RestApiV1;
import com.example.corevo.base.VsResponseUtil;
import com.example.corevo.constant.UrlConstant;
import com.example.corevo.domain.dto.request.user.enter_personal_infomation.PersonalInformationRequestDto;
import com.example.corevo.service.UserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import jakarta.validation.Valid;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.Map;

@RestApiV1
@RequiredArgsConstructor
@Validated
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class UserController {

    UserService userService;
    Cloudinary cloudinary;

    @Operation(
            summary = "Điền thông tin cá nhân",
            description = "Dùng để người dùng điền thông tin cá nhân",
            security = @SecurityRequirement(name = "Bearer Token")
    )
    @PostMapping(UrlConstant.User.FILL_PERSONAL_INFORMATION)
    public ResponseEntity<?> fillPersonalInformation(@Valid @RequestBody PersonalInformationRequestDto request) {
        return VsResponseUtil.success(userService.personalInformation(request));
    }

    @Operation(
            summary = "Tải lên ảnh đại diện",
            description = "Dùng để người dùng tải lên ảnh đại diện",
            security = @SecurityRequirement(name = "Bearer Token")
    )
    @PostMapping(UrlConstant.User.UPLOAD_AVATAR)
    public ResponseEntity<?> uploadAvatar(
            @RequestParam("file") MultipartFile file,
            @RequestParam(name = "id") String id) throws IOException {
        Map<?, ?> result = cloudinary.uploader().upload(file.getBytes(), ObjectUtils.emptyMap());
        String imageUrl = (String) result.get("secure_url");
        return VsResponseUtil.success(userService.uploadAvatar(id, imageUrl));
    }

}
