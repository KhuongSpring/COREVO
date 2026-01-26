package com.example.corevo.controller;

import com.example.corevo.base.RestApiV1;
import com.example.corevo.base.RestData;
import com.example.corevo.base.VsResponseUtil;
import com.example.corevo.constant.UrlConstant;
import com.example.corevo.domain.dto.pagination.PaginationRequestDto;
import com.example.corevo.domain.dto.pagination.PaginationResponseDto;
import com.example.corevo.domain.dto.request.admin.CreateUserRequestDto;
import com.example.corevo.domain.dto.request.admin.UpdateUserRequestDto;
import com.example.corevo.domain.dto.request.user.enter_personal_infomation.PersonalInformationRequestDto;
import com.example.corevo.domain.dto.request.user.profile.UpdateProfileRequestDto;
import com.example.corevo.domain.dto.response.CommonResponseDto;
import com.example.corevo.domain.dto.response.admin.DayCountResponseDto;
import com.example.corevo.domain.dto.response.admin.MonthCountResponseDto;
import com.example.corevo.domain.dto.response.user.AccountDeletionResponseDto;
import com.example.corevo.domain.dto.response.user.UserResponseDto;
import com.example.corevo.service.UserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@RestApiV1
@RequiredArgsConstructor
@Validated
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class UserController {

        UserService userService;

        @Operation(summary = "Điền thông tin cá nhân", description = "Dùng để người dùng điền thông tin cá nhân", security = @SecurityRequirement(name = "Bearer Token"))
        @PostMapping(UrlConstant.User.FILL_PERSONAL_INFORMATION)
        public ResponseEntity<RestData<UserResponseDto>> fillPersonalInformation(
                        Authentication authentication,
                        @Valid @RequestBody PersonalInformationRequestDto request) {
                UserResponseDto response = userService.personalInformation(authentication, request);
                return VsResponseUtil.success(response);
        }

        @Operation(summary = "Tải lên ảnh đại diện", description = "Dùng để người dùng tải lên ảnh đại diện", security = @SecurityRequirement(name = "Bearer Token"))
        @PostMapping(UrlConstant.User.UPLOAD_AVATAR)
        public ResponseEntity<RestData<UserResponseDto>> uploadAvatar(
                        @RequestParam("file") MultipartFile file,
                        Authentication authentication) {
                UserResponseDto response = userService.uploadAvatar(authentication, file);
                return VsResponseUtil.success(response);
        }

        @Operation(summary = "Xóa tài khoản", description = "Dùng để người dùng xóa tài khoản của mình (soft delete, có thể khôi phục trong 30 ngày)", security = @SecurityRequirement(name = "Bearer Token"))
        @DeleteMapping(UrlConstant.User.DELETE_MY_ACCOUNT)
        public ResponseEntity<RestData<AccountDeletionResponseDto>> deleteMyAccount(Authentication authentication) {
                AccountDeletionResponseDto response = userService.deleteMyAccount(authentication);
                return VsResponseUtil.success(response);
        }

        @Operation(summary = "Lấy thông tin profile (thông tin user và user health)", description = "Dùng để người dùng lấy thông tin profile đầy đủ (thông tin cá nhân + sức khỏe)", security = @SecurityRequirement(name = "Bearer Token"))
        @GetMapping(UrlConstant.User.GET_PROFILE)
        public ResponseEntity<RestData<UserResponseDto>> getMyProfile(Authentication authentication) {
                UserResponseDto response = userService.getMyProfile(authentication);
                return VsResponseUtil.success(response);
        }

        @Operation(summary = "Cập nhật thông tin profile", description = "Dùng để người dùng cập nhật thông tin cá nhân và sức khỏe với xác nhận mật khẩu", security = @SecurityRequirement(name = "Bearer Token"))
        @PutMapping(UrlConstant.User.UPDATE_PROFILE)
        public ResponseEntity<RestData<UserResponseDto>> updateProfile(
                        @Valid @RequestBody UpdateProfileRequestDto request,
                        Authentication authentication) {
                UserResponseDto response = userService.updateProfile(request, authentication);
                return VsResponseUtil.success(response);
        }

        // //
        // Methods for ADMIN //
        // //

        @Tag(name = "admin-controller")
        @Operation(summary = "Lấy thông tin của toàn bộ user", description = "Dùng để admin lấy thông tin toàn bộ user", security = @SecurityRequirement(name = "Bearer Token"))
        @GetMapping(UrlConstant.Admin.GET_USERS)
        public ResponseEntity<RestData<PaginationResponseDto<UserResponseDto>>> getAllUsers(
                        @ModelAttribute PaginationRequestDto request) {
                PaginationResponseDto<UserResponseDto> response = userService.getAllUsers(request);
                return VsResponseUtil.success(response);
        }

        @Tag(name = "admin-controller")
        @Operation(summary = "Lấy thông tin user theo ID", description = "Dùng để admin lấy thông tin chi tiết của một user", security = @SecurityRequirement(name = "Bearer Token"))
        @GetMapping(UrlConstant.Admin.GET_USER)
        public ResponseEntity<RestData<UserResponseDto>> getUserById(@PathVariable String userId) {
                UserResponseDto response = userService.getUserById(userId);
                return VsResponseUtil.success(response);
        }

        @Tag(name = "admin-controller")
        @Operation(summary = "Tạo user mới", description = "Dùng để admin tạo user mới trong hệ thống", security = @SecurityRequirement(name = "Bearer Token"))
        @PostMapping(UrlConstant.Admin.CREATE_USER)
        public ResponseEntity<RestData<UserResponseDto>> createUser(@Valid @RequestBody CreateUserRequestDto request) {
                UserResponseDto response = userService.createUser(request);
                return VsResponseUtil.success(response);
        }

        @Tag(name = "admin-controller")
        @Operation(summary = "Cập nhật thông tin user", description = "Dùng để admin cập nhật thông tin của một user", security = @SecurityRequirement(name = "Bearer Token"))
        @PutMapping(UrlConstant.Admin.UPDATE_USER)
        public ResponseEntity<RestData<UserResponseDto>> updateUser(
                        @PathVariable String userId,
                        @Valid @RequestBody UpdateUserRequestDto request) {
                UserResponseDto response = userService.updateUser(userId, request);
                return VsResponseUtil.success(response);
        }

        @Tag(name = "admin-controller")
        @Operation(summary = "Khóa tài khoản user", description = "Dùng để admin khóa tài khoản user (user không thể đăng nhập)", security = @SecurityRequirement(name = "Bearer Token"))
        @PutMapping(UrlConstant.Admin.LOCK_USER)
        public ResponseEntity<RestData<CommonResponseDto>> lockUser(@PathVariable String userId) {
                CommonResponseDto response = userService.lockUser(userId);
                return VsResponseUtil.success(response);
        }

        @Tag(name = "admin-controller")
        @Operation(summary = "Mở khóa tài khoản user", description = "Dùng để admin mở khóa tài khoản user", security = @SecurityRequirement(name = "Bearer Token"))
        @PutMapping(UrlConstant.Admin.UNLOCK_USER)
        public ResponseEntity<RestData<CommonResponseDto>> unlockUser(@PathVariable String userId) {
                CommonResponseDto response = userService.unlockUser(userId);
                return VsResponseUtil.success(response);
        }

        @Tag(name = "admin-controller")
        @Operation(summary = "Xóa user vĩnh viễn", description = "Dùng để admin xóa user khỏi hệ thống (không thể khôi phục)", security = @SecurityRequirement(name = "Bearer Token"))
        @DeleteMapping(UrlConstant.Admin.DELETE_USER)
        public ResponseEntity<RestData<CommonResponseDto>> deleteUserPermanently(@PathVariable String userId) {
                CommonResponseDto response = userService.deleteUserAccount(userId);
                return VsResponseUtil.success(response);
        }

        @Tag(name = "admin-controller")
        @Operation(summary = "Tìm kiếm user bằng tên", description = "Dùng để admin tìm kiếm người dùng bằng tên", security = @SecurityRequirement(name = "Bearer Token"))
        @GetMapping(UrlConstant.Admin.SEARCH_USER_BY_USERNAME)
        public ResponseEntity<RestData<PaginationResponseDto<UserResponseDto>>> searchUserByUsername(
                        @RequestParam(required = true) String searchSentence,
                        @ModelAttribute PaginationRequestDto request) {
                PaginationResponseDto<UserResponseDto> response = userService.searchUserByUsername(searchSentence,
                                request);
                return VsResponseUtil.success(response);
        }

        @Tag(name = "admin-controller")
        @Operation(summary = "Tìm kiếm user bằng email", description = "Dùng để admin tìm kiếm người dùng bằng email", security = @SecurityRequirement(name = "Bearer Token"))
        @GetMapping(UrlConstant.Admin.SEARCH_USER_BY_EMAIL)
        public ResponseEntity<RestData<PaginationResponseDto<UserResponseDto>>> searchUserByEmail(
                        @RequestParam(required = true) String searchSentence,
                        @ModelAttribute PaginationRequestDto request) {
                PaginationResponseDto<UserResponseDto> response = userService.searchUserByEmail(searchSentence,
                                request);
                return VsResponseUtil.success(response);
        }

        @Tag(name = "admin-controller")
        @Operation(summary = "Tìm kiếm user bằng số điện thoại", description = "Dùng để admin tìm kiếm người dùng bằng số điện thoại", security = @SecurityRequirement(name = "Bearer Token"))
        @GetMapping(UrlConstant.Admin.SEARCH_USER_BY_PHONE)
        public ResponseEntity<RestData<PaginationResponseDto<UserResponseDto>>> searchUserByPhone(
                        @RequestParam(required = true) String searchSentence,
                        @ModelAttribute PaginationRequestDto request) {
                PaginationResponseDto<UserResponseDto> response = userService.searchUserByPhone(searchSentence,
                                request);
                return VsResponseUtil.success(response);
        }

        @Tag(name = "admin-controller")
        @Operation(summary = "Số lượng user tăng theo ngày", description = "Dùng để tính số lượng User đăng ký thêm trong 7 ngày", security = @SecurityRequirement(name = "Bearer Token"))
        @GetMapping(UrlConstant.Admin.GET_USER_DAY)
        public ResponseEntity<RestData<List<DayCountResponseDto>>> getUserDayCounts() {
                List<DayCountResponseDto> response = userService.getUserDayCounts();
                return VsResponseUtil.success(response);
        }

        @Tag(name = "admin-controller")
        @Operation(summary = "Số lượng user tăng theo tháng", description = "Dùng để tính số lượng User đăng ký thêm trong 12 tháng gần nhất", security = @SecurityRequirement(name = "Bearer Token"))
        @GetMapping(UrlConstant.Admin.GET_USER_MONTH)
        public ResponseEntity<RestData<List<MonthCountResponseDto>>> getUserMonthCounts() {
                List<MonthCountResponseDto> response = userService.getUserMonthCounts();
                return VsResponseUtil.success(response);
        }

}
