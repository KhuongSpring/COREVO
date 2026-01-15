package com.example.corevo.service;

import com.example.corevo.domain.dto.pagination.PaginationRequestDto;
import com.example.corevo.domain.dto.pagination.PaginationResponseDto;
import com.example.corevo.domain.dto.request.admin.CreateUserRequestDto;
import com.example.corevo.domain.dto.request.admin.UpdateUserRequestDto;
import com.example.corevo.domain.dto.request.user.enter_personal_infomation.PersonalInformationRequestDto;
import com.example.corevo.domain.dto.request.user.profile.ConfirmPasswordRequestDto;
import com.example.corevo.domain.dto.request.user.sreach.UserSearchingRequestDto;
import com.example.corevo.domain.dto.response.CommonResponseDto;
import com.example.corevo.domain.dto.response.admin.DayCountResponseDto;
import com.example.corevo.domain.dto.response.admin.MonthCountResponseDto;
import com.example.corevo.domain.dto.response.user.AccountDeletionResponseDto;
import com.example.corevo.domain.dto.response.user.UserResponseDto;
import org.springframework.security.core.Authentication;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

import java.util.List;

public interface UserService {

        UserResponseDto personalInformation(Authentication authentication, PersonalInformationRequestDto request);

        UserResponseDto uploadAvatar(Authentication authentication, MultipartFile file) throws IOException;

        AccountDeletionResponseDto deleteMyAccount(Authentication authentication);

        UserResponseDto getMyProfile(Authentication authentication);

        UserResponseDto updateProfile(ConfirmPasswordRequestDto request, Authentication authentication);

        PaginationResponseDto<UserResponseDto> getAllUsers(PaginationRequestDto request);

        UserResponseDto getUserById(String userId);

        UserResponseDto createUser(CreateUserRequestDto request);

        UserResponseDto updateUser(String userId, UpdateUserRequestDto request);

        CommonResponseDto lockUser(String userId);

        CommonResponseDto unlockUser(String userId);

        CommonResponseDto deleteUserAccount(String userId);

        PaginationResponseDto<UserResponseDto> searchUserByUsername(UserSearchingRequestDto request,
                        PaginationRequestDto paginationRequestDto);

        PaginationResponseDto<UserResponseDto> searchUserByEmail(UserSearchingRequestDto request,
                        PaginationRequestDto paginationRequestDto);

        PaginationResponseDto<UserResponseDto> searchUserByPhone(UserSearchingRequestDto request,
                        PaginationRequestDto paginationRequestDto);

        List<DayCountResponseDto> getUserDayCounts();

        List<MonthCountResponseDto> getUserMonthCounts();
}
