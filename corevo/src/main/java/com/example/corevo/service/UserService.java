package com.example.corevo.service;

import com.example.corevo.domain.dto.request.user.enter_personal_infomation.PersonalInformationRequestDto;
import com.example.corevo.domain.dto.response.user.UserResponseDto;

public interface UserService {
    UserResponseDto personalInformation(PersonalInformationRequestDto request);
    UserResponseDto uploadAvatar(String id, String url);
}
