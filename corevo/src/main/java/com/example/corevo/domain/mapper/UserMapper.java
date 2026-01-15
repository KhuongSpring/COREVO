package com.example.corevo.domain.mapper;

import com.example.corevo.domain.dto.request.admin.UpdateUserRequestDto;
import com.example.corevo.domain.dto.request.user.enter_personal_infomation.UpdatePersonalInformationRequestDto;
import org.mapstruct.*;

import com.example.corevo.domain.dto.request.admin.CreateUserRequestDto;
import com.example.corevo.domain.dto.response.user.UserResponseDto;
import com.example.corevo.domain.entity.user.User;

@Mapper(componentModel = "spring", nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE, nullValueCheckStrategy = NullValueCheckStrategy.ALWAYS)
public interface UserMapper {

    UserResponseDto userToUserResponseDto(User user);

    User createUserRequestDtoToUser(CreateUserRequestDto request);

    void updateUserFromDto(UpdateUserRequestDto request, @MappingTarget User user);

    void updateUserFromPersonalInformationDto(UpdatePersonalInformationRequestDto request, @MappingTarget User user);
}
