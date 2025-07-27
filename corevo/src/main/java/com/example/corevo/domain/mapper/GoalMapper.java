package com.example.corevo.domain.mapper;

import com.example.corevo.domain.dto.response.training.GoalResponseDto;
import com.example.corevo.domain.entity.training.Goal;
import org.mapstruct.Mapper;
import org.mapstruct.NullValueCheckStrategy;
import org.mapstruct.NullValuePropertyMappingStrategy;

import java.util.List;

@Mapper(componentModel = "spring",
        nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE,
        nullValueCheckStrategy = NullValueCheckStrategy.ALWAYS
)
public interface GoalMapper {

    List<GoalResponseDto> listGoalToListGoalResponseDto(List<Goal> goals);

    GoalResponseDto goalToGoalResponseDto(Goal goal);

}
