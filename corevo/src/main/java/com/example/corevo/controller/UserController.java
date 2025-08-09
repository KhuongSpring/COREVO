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
import com.example.corevo.domain.dto.request.training.TrainingExerciseSearchingRequestDto;
import com.example.corevo.domain.dto.request.user.enter_personal_infomation.PersonalInformationRequestDto;
import com.example.corevo.domain.dto.request.user.profile.ConfirmPasswordRequestDto;
import com.example.corevo.domain.dto.request.user.sreach.UserSearchingRequestDto;
import com.example.corevo.domain.entity.user.User;
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
import org.springframework.security.core.parameters.P;
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

    @Operation(
            summary = "Điền thông tin cá nhân",
            description = "Dùng để người dùng điền thông tin cá nhân",
            security = @SecurityRequirement(name = "Bearer Token")
    )
    @PostMapping(UrlConstant.User.FILL_PERSONAL_INFORMATION)
    public ResponseEntity<?> fillPersonalInformation(
            Authentication authentication,
            @Valid @RequestBody PersonalInformationRequestDto request
    ) {
        return VsResponseUtil.success(userService.personalInformation(authentication, request));
    }

    @Operation(
            summary = "Tải lên ảnh đại diện",
            description = "Dùng để người dùng tải lên ảnh đại diện",
            security = @SecurityRequirement(name = "Bearer Token")
    )
    @PostMapping(UrlConstant.User.UPLOAD_AVATAR)
    public ResponseEntity<?> uploadAvatar(
            @RequestParam("file") MultipartFile file,
            Authentication authentication
    ) throws IOException {
            return VsResponseUtil.success(userService.uploadAvatar(authentication, file));
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

    @Operation(
            summary = "Lấy thông tin profile (thông tin user và user health)",
            description = "Dùng để người dùng lấy thông tin profile đầy đủ (thông tin cá nhân + sức khỏe)",
            security = @SecurityRequirement(name = "Bearer Token")
    )
    @GetMapping(UrlConstant.User.GET_PROFILE)
    public ResponseEntity<?> getMyProfile(Authentication authentication) {
        return VsResponseUtil.success(userService.getMyProfile(authentication));
    }

    @Operation(
            summary = "Cập nhật thông tin profile",
            description = "Dùng để người dùng cập nhật thông tin cá nhân và sức khỏe với xác nhận mật khẩu",
            security = @SecurityRequirement(name = "Bearer Token")
    )
    @PutMapping(UrlConstant.User.UPDATE_PROFILE)
    public ResponseEntity<?> updateProfile(
            @Valid @RequestBody ConfirmPasswordRequestDto request,
            Authentication authentication
    ) {
        return VsResponseUtil.success(userService.updateProfile(request, authentication));
    }

    //                                  //
    //          Methods for ADMIN       //
    //                                  //

    @Tag(name = "admin-controller")
    @Operation(
            summary = "Lấy thông tin của toàn bộ user",
            description = "Dùng để admin lấy thông tin toàn bộ user",
            security = @SecurityRequirement(name = "Bearer Token")
    )
    @GetMapping(UrlConstant.Admin.GET_USERS)
    public ResponseEntity<?> getAllUsers(
            @RequestParam(name = "pageNum", defaultValue = "0") int pageNum,
            @RequestParam(name = "pageSize", defaultValue = "0") int pageSize
    ) {
        PaginationRequestDto request = new PaginationRequestDto(pageNum, pageSize);
        return VsResponseUtil.success(userService.getAllUsers(request));
    }

    @Tag(name = "admin-controller")
    @Operation(
            summary = "Lấy thông tin user theo ID",
            description = "Dùng để admin lấy thông tin chi tiết của một user",
            security = @SecurityRequirement(name = "Bearer Token")
    )
    @GetMapping(UrlConstant.Admin.GET_USER)
    public ResponseEntity<?> getUserById(@PathVariable String userId) {
        return VsResponseUtil.success(userService.getUserById(userId));
    }

    @Tag(name = "admin-controller")
    @Operation(
            summary = "Tạo user mới",
            description = "Dùng để admin tạo user mới trong hệ thống",
            security = @SecurityRequirement(name = "Bearer Token")
    )
    @PostMapping(UrlConstant.Admin.CREATE_USER)
    public ResponseEntity<?> createUser(@Valid @RequestBody CreateUserRequestDto request) {
        return VsResponseUtil.success(userService.createUser(request));
    }

    @Tag(name = "admin-controller")
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

    @Tag(name = "admin-controller")
    @Operation(
            summary = "Khóa tài khoản user",
            description = "Dùng để admin khóa tài khoản user (user không thể đăng nhập)",
            security = @SecurityRequirement(name = "Bearer Token")
    )
    @PutMapping(UrlConstant.Admin.LOCK_USER)
    public ResponseEntity<?> lockUser(@PathVariable String userId) {
        return VsResponseUtil.success(userService.lockUser(userId));
    }

    @Tag(name = "admin-controller")
    @Operation(
            summary = "Mở khóa tài khoản user",
            description = "Dùng để admin mở khóa tài khoản user",
            security = @SecurityRequirement(name = "Bearer Token")
    )
    @PutMapping(UrlConstant.Admin.UNLOCK_USER)
    public ResponseEntity<?> unlockUser(@PathVariable String userId) {
        return VsResponseUtil.success(userService.unlockUser(userId));
    }

    @Tag(name = "admin-controller")
    @Operation(
            summary = "Xóa user vĩnh viễn",
            description = "Dùng để admin xóa user khỏi hệ thống (không thể khôi phục)",
            security = @SecurityRequirement(name = "Bearer Token")
    )
    @DeleteMapping(UrlConstant.Admin.DELETE_USER)
    public ResponseEntity<?> deleteUserPermanently(@PathVariable String userId) {
        return VsResponseUtil.success(userService.deleteUserAccount(userId));
    }

    @Tag(name = "admin-controller")
    @Operation(
            summary = "Tìm kiếm user bằng tên",
            description = "Dùng để admin tìm kiếm người dùng bằng tên",
            security = @SecurityRequirement(name = "Bearer Token")
    )
    @PostMapping(UrlConstant.Admin.SEARCH_USER_BY_USERNAME)
    public ResponseEntity<?> searchUserByUsername(
            @Valid @RequestBody UserSearchingRequestDto searchRequest,
            @RequestParam(name = "pageNum", defaultValue = "1") int PageNum,
            @RequestParam(name = "pageSize", defaultValue = "1") int PageSize){
        PaginationRequestDto request = new PaginationRequestDto(PageNum, PageSize);
        return VsResponseUtil.success(userService.searchUserByUsername(searchRequest, request));
    }

    @Tag(name = "admin-controller")
    @Operation(
            summary = "Tìm kiếm user bằng email",
            description = "Dùng để admin tìm kiếm người dùng bằng email",
            security = @SecurityRequirement(name = "Bearer Token")
    )
    @PostMapping(UrlConstant.Admin.SEARCH_USER_BY_EMAIL)
    public ResponseEntity<?> searchUserByEmail(
            @Valid @RequestBody UserSearchingRequestDto searchRequest,
            @RequestParam(name = "pageNum", defaultValue = "1") int PageNum,
            @RequestParam(name = "pageSize", defaultValue = "1") int PageSize){
        PaginationRequestDto request = new PaginationRequestDto(PageNum, PageSize);
        return VsResponseUtil.success(userService.searchUserByEmail(searchRequest, request));
    }

    @Tag(name = "admin-controller")
    @Operation(
            summary = "Tìm kiếm user bằng số điện thoại",
            description = "Dùng để admin tìm kiếm người dùng bằng số điện thoại",
            security = @SecurityRequirement(name = "Bearer Token")
    )
    @PostMapping(UrlConstant.Admin.SEARCH_USER_BY_PHONE)
    public ResponseEntity<?> searchUserByPhone(
            @Valid @RequestBody UserSearchingRequestDto searchRequest,
            @RequestParam(name = "pageNum", defaultValue = "1") int PageNum,
            @RequestParam(name = "pageSize", defaultValue = "1") int PageSize){
        PaginationRequestDto request = new PaginationRequestDto(PageNum, PageSize);
        return VsResponseUtil.success(userService.searchUserByPhone(searchRequest, request));
    }

    @Tag(name = "admin-controller")
    @Operation(
            summary = "Số lượng user tăng theo ngày",
            description = "Dùng để tính số lượng User đăng ký thêm trong 7 ngày",
            security = @SecurityRequirement(name = "Bearer Token")
    )
    @PostMapping(UrlConstant.Admin.GET_USER_DAY)
    public ResponseEntity<?> getUserDayCounts(){
        return VsResponseUtil.success(userService.getUserDayCounts());
    }

    @Tag(name = "admin-controller")
    @Operation(
            summary = "Số lượng user tăng theo tháng",
            description = "Dùng để tính số lượng User đăng ký thêm trong 12 tháng gần nhất",
            security = @SecurityRequirement(name = "Bearer Token")
    )
    @PostMapping(UrlConstant.Admin.GET_USER_MONTH)
    public ResponseEntity<?> getUserMonthCounts(){
        return VsResponseUtil.success(userService.getUserMonthCounts());
    }

}
