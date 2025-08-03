package com.example.corevo.domain.mapper;

import com.example.corevo.domain.dto.response.training_schedule.TrainingExerciseGroupResponseDto;
import com.example.corevo.domain.entity.training.training_schedule_details.TrainingExerciseGroup;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.NullValueCheckStrategy;
import org.mapstruct.NullValuePropertyMappingStrategy;

@Mapper(componentModel = "spring",
        uses = TrainingExerciseGroupDetailMapper.class,
        nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE,
        nullValueCheckStrategy = NullValueCheckStrategy.ALWAYS
)
public interface TrainingExerciseGroupMapper {

    @Mapping(target = "exercises", source = "exercises")
    TrainingExerciseGroup trainingExerciseGroupResponseDtoToTrainingExerciseGroup(TrainingExerciseGroupResponseDto dto);

    @Mapping(target = "exercises", source = "exercises")
    TrainingExerciseGroupResponseDto trainingExerciseGroupToTrainingExerciseGroupResponseDto(TrainingExerciseGroup entity);
}

