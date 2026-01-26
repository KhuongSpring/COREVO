package com.example.corevo.domain.mapper;

import com.example.corevo.domain.dto.request.user.health.UpdateHealthRequestDto;
import com.example.corevo.domain.dto.response.user.health.UserHealthResponseDto;
import com.example.corevo.domain.entity.user.UserHealth;
import org.mapstruct.*;

@Mapper(componentModel = "spring", nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE, nullValueCheckStrategy = NullValueCheckStrategy.ALWAYS)
public interface UserHealthMapper {

    void updateUserHealthFromDto(UpdateHealthRequestDto request, @MappingTarget UserHealth userHealth);

    UserHealthResponseDto userHealthToUserHealthResponseDto(UserHealth userHealth);
}
