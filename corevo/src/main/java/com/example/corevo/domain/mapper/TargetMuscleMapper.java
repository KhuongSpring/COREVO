package com.example.corevo.domain.mapper;

import com.example.corevo.domain.dto.response.training.TargetMuscleResponseDto;
import com.example.corevo.domain.entity.training.TargetMuscle;
import org.mapstruct.Mapper;
import org.mapstruct.NullValueCheckStrategy;
import org.mapstruct.NullValuePropertyMappingStrategy;

import java.util.List;

@Mapper(componentModel = "spring",
        nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE,
        nullValueCheckStrategy = NullValueCheckStrategy.ALWAYS
)
public interface TargetMuscleMapper {

    List<TargetMuscleResponseDto> listTargetMuscleToListTargetMuscleResponseDto(List<TargetMuscle> targetMuscles);

    TargetMuscleResponseDto targetMuscleToTargetMuscleResponseDto(TargetMuscle targetMuscle);

}
