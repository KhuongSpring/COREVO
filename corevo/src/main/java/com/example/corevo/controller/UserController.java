package com.example.corevo.controller;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import com.example.corevo.base.RestApiV1;
import com.example.corevo.base.VsResponseUtil;
import com.example.corevo.constant.ErrorMessage;
import com.example.corevo.constant.UrlConstant;
import com.example.corevo.domain.dto.pagination.PaginationRequestDto;
import com.example.corevo.domain.dto.request.admin.CreateUserRequestDto;
import com.example.corevo.domain.dto.request.admin.UpdateUserRequestDto;
import com.example.corevo.domain.dto.request.user.enter_personal_infomation.PersonalInformationRequestDto;
import com.example.corevo.exception.VsException;
import com.example.corevo.service.UserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
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
        try {
            Map<?, ?> result = cloudinary.uploader().upload(file.getBytes(), ObjectUtils.emptyMap());
            String imageUrl = (String) result.get("secure_url");
            return VsResponseUtil.success(userService.uploadAvatar(id, imageUrl));
        } catch (Exception e){
            throw new VsException(HttpStatus.INTERNAL_SERVER_ERROR, ErrorMessage.ERR_UPLOAD_IMAGE_FAIL);
        }
    }

    @Operation(
            summary = "Xóa tài khoản",
            description = "Dùng để người dùng xóa tài khoản của mình (soft delete, có thể khôi phục trong 30 ngày)",
            security = @SecurityRequirement(name = "Bearer Token")
    )
    @DeleteMapping(UrlConstant.User.DELETE_MY_ACCOUNT)
    public ResponseEntity<?> deleteMyAccount(Authentication authentication) {
        return VsResponseUtil.success(userService.deleteMyAccount(authentication));
    }
                                                    
    //                                  //
    //          Methods for ADMIN       //
    //                                  //

    @Tag(name = "user-controller-admin")
    @Operation(
                summary = "Lấy thông tin của toàn bộ user",
                description = "Dùng để admin lấy thông tin toàn bộ user",
                security = @SecurityRequirement(name = "Bearer Token")
    )
    @GetMapping(UrlConstant.Admin.GET_USERS)
    public ResponseEntity<?> getAllUsers(
        @RequestParam(name = "page num", defaultValue = "0") int pageNum,
        @RequestParam(name = "page size", defaultValue = "0") int pageSize
    ) {
        PaginationRequestDto request = new PaginationRequestDto(pageNum, pageSize);
        return VsResponseUtil.success(userService.getAllUsers(request));
    }

    @Tag(name = "user-controller-admin")
    @Operation(
            summary = "Lấy thông tin user theo ID",
            description = "Dùng để admin lấy thông tin chi tiết của một user",
            security = @SecurityRequirement(name = "Bearer Token")
    )
    @GetMapping(UrlConstant.Admin.GET_USER)
    public ResponseEntity<?> getUserById(@PathVariable String userId) {
        return VsResponseUtil.success(userService.getUserById(userId));
    }

    @Tag(name = "user-controller-admin")
    @Operation(
            summary = "Tạo user mới",
            description = "Dùng để admin tạo user mới trong hệ thống",
            security = @SecurityRequirement(name = "Bearer Token")
    )
    @PostMapping(UrlConstant.Admin.CREATE_USER)
    public ResponseEntity<?> createUser(@Valid @RequestBody CreateUserRequestDto request) {
        return VsResponseUtil.success(userService.createUser(request));
    }

    @Tag(name = "user-controller-admin")
    @Operation(
            summary = "Cập nhật thông tin user",
            description = "Dùng để admin cập nhật thông tin của một user", 
            security = @SecurityRequirement(name = "Bearer Token")
    )
    @PutMapping(UrlConstant.Admin.UPDATE_USER)
    public ResponseEntity<?> updateUser(
            @PathVariable String userId,
            @Valid @RequestBody UpdateUserRequestDto request) {
        return VsResponseUtil.success(userService.updateUser(userId, request));
    }

    @Tag(name = "user-controller-admin")
    @Operation(
            summary = "Khóa tài khoản user",
            description = "Dùng để admin khóa tài khoản user (user không thể đăng nhập)",
            security = @SecurityRequirement(name = "Bearer Token")
    )
    @PutMapping(UrlConstant.Admin.LOCK_USER)
    public ResponseEntity<?> lockUser(@PathVariable String userId) {
        return VsResponseUtil.success(userService.lockUser(userId));
    }

    @Tag(name = "user-controller-admin")
    @Operation(
            summary = "Mở khóa tài khoản user",
            description = "Dùng để admin mở khóa tài khoản user",
            security = @SecurityRequirement(name = "Bearer Token")
    )
    @PutMapping(UrlConstant.Admin.UNLOCK_USER)
    public ResponseEntity<?> unlockUser(@PathVariable String userId) {
        return VsResponseUtil.success(userService.unlockUser(userId));
    }

    @Tag(name = "user-controller-admin")
    @Operation(
            summary = "Xóa user vĩnh viễn",
            description = "Dùng để admin xóa user khỏi hệ thống (không thể khôi phục)",
            security = @SecurityRequirement(name = "Bearer Token")
    )
    @DeleteMapping(UrlConstant.Admin.DELETE_USER)
    public ResponseEntity<?> deleteUserPermanently(@PathVariable String userId) {
        return VsResponseUtil.success(userService.deleteUserAccount(userId));
    }

}
