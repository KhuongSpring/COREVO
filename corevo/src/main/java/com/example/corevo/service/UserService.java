package com.example.corevo.service;

import com.example.corevo.domain.dto.pagination.PaginationRequestDto;
import com.example.corevo.domain.dto.pagination.PaginationResponseDto;
import com.example.corevo.domain.dto.request.admin.CreateUserRequestDto;
import com.example.corevo.domain.dto.request.admin.UpdateUserRequestDto;
import com.example.corevo.domain.dto.request.user.enter_personal_infomation.PersonalInformationRequestDto;
import com.example.corevo.domain.dto.request.user.profile.ConfirmPasswordRequestDto;
import com.example.corevo.domain.dto.response.CommonResponseDto;
import com.example.corevo.domain.dto.response.user.AccountDeletionResponseDto;
import com.example.corevo.domain.dto.response.user.UserResponseDto;
import com.example.corevo.domain.entity.user.User;
import org.springframework.security.core.Authentication;

public interface UserService {

    UserResponseDto personalInformation(Authentication authentication, PersonalInformationRequestDto request);

    UserResponseDto uploadAvatar(Authentication authentication, String url);

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

    User findOrCreateUser(String email, String name, String picture, String firstName, String lastName);

    long countAllUser();

}
