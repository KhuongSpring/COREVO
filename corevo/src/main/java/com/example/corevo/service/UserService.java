package com.example.corevo.service;

import com.example.corevo.domain.dto.pagination.PaginationRequestDto;
import com.example.corevo.domain.dto.pagination.PaginationResponseDto;
import com.example.corevo.domain.dto.request.admin.CreateUserRequestDto;
import com.example.corevo.domain.dto.request.admin.UpdateUserRequestDto;
import com.example.corevo.domain.dto.request.user.enter_personal_infomation.PersonalInformationRequestDto;
import com.example.corevo.domain.dto.response.CommonResponseDto;
import com.example.corevo.domain.dto.response.user.UserResponseDto;

public interface UserService {
    UserResponseDto personalInformation(PersonalInformationRequestDto request);

    UserResponseDto uploadAvatar(String id, String url);

    // UserResponseDto getCurrentUser();

    PaginationResponseDto<UserResponseDto> getAllUsers(PaginationRequestDto request);

    UserResponseDto getUserById(String userId);

    UserResponseDto createUser(CreateUserRequestDto request);

    UserResponseDto updateUser(String userId, UpdateUserRequestDto request);

    CommonResponseDto lockUser(String userId);

    CommonResponseDto unlockUser(String userId);

    CommonResponseDto deleteUserPermanently(String userId);
}
