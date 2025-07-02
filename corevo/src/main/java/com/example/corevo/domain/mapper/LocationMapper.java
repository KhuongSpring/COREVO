package com.example.corevo.domain.mapper;

import com.example.corevo.domain.dto.response.training.LocationResponseDto;
import com.example.corevo.domain.entity.training.Location;
import org.mapstruct.Mapper;
import org.mapstruct.NullValueCheckStrategy;
import org.mapstruct.NullValuePropertyMappingStrategy;

import java.util.List;

@Mapper(componentModel = "spring",
        nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE,
        nullValueCheckStrategy = NullValueCheckStrategy.ALWAYS
)
public interface LocationMapper {

    List<LocationResponseDto> listLocationToListLocationResponseDto(List<Location> locations);

}
