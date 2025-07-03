package com.example.corevo.domain.mapper;

import com.example.corevo.domain.dto.response.training.LevelResponseDto;
import com.example.corevo.domain.entity.training.Level;
import org.mapstruct.Mapper;
import org.mapstruct.NullValueCheckStrategy;
import org.mapstruct.NullValuePropertyMappingStrategy;

import java.util.List;

@Mapper(componentModel = "spring",
        nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE,
        nullValueCheckStrategy = NullValueCheckStrategy.ALWAYS
)
public interface LevelMapper {

    List<LevelResponseDto> listLevelToListLevelResponseDto(List<Level> levels);

}
