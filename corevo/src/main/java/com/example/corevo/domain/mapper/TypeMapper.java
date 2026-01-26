package com.example.corevo.domain.mapper;

import com.example.corevo.domain.dto.response.training.TypeResponseDto;
import com.example.corevo.domain.entity.training.Type;
import org.mapstruct.Mapper;
import org.mapstruct.NullValueCheckStrategy;
import org.mapstruct.NullValuePropertyMappingStrategy;

import java.util.List;

@Mapper(componentModel = "spring", nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE, nullValueCheckStrategy = NullValueCheckStrategy.ALWAYS)
public interface TypeMapper {

    List<TypeResponseDto> listTypeToListTypeResponseDto(List<Type> types);

    TypeResponseDto typeToTypeResponseDto(Type type);

}
