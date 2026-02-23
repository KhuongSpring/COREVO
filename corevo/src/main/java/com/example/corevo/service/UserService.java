package com.example.corevo.service;

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
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.UUID;

public interface UserService {

        UserResponseDto personalInformation(UUID userId, PersonalInformationRequestDto request);

        UserResponseDto uploadAvatar(UUID userId, MultipartFile file);

        AccountDeletionResponseDto deleteMyAccount(UUID userId);

        UserResponseDto getMyProfile(UUID userId);

        UserResponseDto updateProfile(UpdateProfileRequestDto request, UUID userId);

        PaginationResponseDto<UserResponseDto> getAllUsers(PaginationRequestDto request);

        UserResponseDto getUserById(UUID userId);

        UserResponseDto createUser(CreateUserRequestDto request);

        UserResponseDto updateUser(UUID userId, UpdateUserRequestDto request);

        CommonResponseDto lockUser(UUID userId);

        CommonResponseDto unlockUser(UUID userId);

        CommonResponseDto deleteUserAccount(UUID userId);

        PaginationResponseDto<UserResponseDto> searchUserByUsername(String searchSentence,
                        PaginationRequestDto paginationRequestDto);

        PaginationResponseDto<UserResponseDto> searchUserByEmail(String searchSentence,
                        PaginationRequestDto paginationRequestDto);

        PaginationResponseDto<UserResponseDto> searchUserByPhone(String searchSentence,
                        PaginationRequestDto paginationRequestDto);

        List<DayCountResponseDto> getUserDayCounts();

        List<MonthCountResponseDto> getUserMonthCounts();
}
