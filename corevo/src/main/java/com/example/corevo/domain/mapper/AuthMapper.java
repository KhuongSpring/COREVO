package com.example.corevo.domain.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.NullValueCheckStrategy;
import org.mapstruct.NullValuePropertyMappingStrategy;

import com.example.corevo.domain.dto.request.auth.RegisterRequestDto;
import com.example.corevo.domain.dto.response.user.UserResponseDto;
import com.example.corevo.domain.entity.User;

@Mapper(componentModel = "spring", nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE, nullValueCheckStrategy = NullValueCheckStrategy.ALWAYS)
public interface AuthMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "password", ignore = true)
    @Mapping(target = "role", ignore = true)
    @Mapping(target = "createdAt", ignore = true)
    @Mapping(target = "isLocked", ignore = true)
    @Mapping(target = "address", ignore = true)
    @Mapping(target = "userHealth", ignore = true)
    User toUser(RegisterRequestDto request);

    UserResponseDto toUserResponseDto(User user);
}
