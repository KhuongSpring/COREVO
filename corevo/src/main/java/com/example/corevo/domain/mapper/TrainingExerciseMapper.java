package com.example.corevo.domain.mapper;

import com.example.corevo.domain.dto.response.training.TrainingExerciseResponseDto;
import com.example.corevo.domain.entity.TrainingExercise;
import com.example.corevo.helper.IdToEntityHelper;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.NullValueCheckStrategy;
import org.mapstruct.NullValuePropertyMappingStrategy;

import java.util.List;

@Mapper(componentModel = "spring",
        uses = IdToEntityHelper.class,
        nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE,
        nullValueCheckStrategy = NullValueCheckStrategy.ALWAYS
)
public interface TrainingExerciseMapper {
    @Mapping(target = "levels", source = "levelIds")
    @Mapping(target = "types", source = "typeIds")
    @Mapping(target = "primaryMuscles", source = "primaryMuscleIds")
    @Mapping(target = "secondaryMuscles", source = "secondaryMuscleIds")
    @Mapping(target = "equipments", source = "equipmentIds")
    @Mapping(target = "locations", source = "locationIds")
    @Mapping(target = "goals", source = "goalIds")
    TrainingExercise trainingExerciseResponseDtoToTrainingExercise(TrainingExerciseResponseDto dto);

    List<TrainingExercise> ListTrainingExerciseResponseDtoToListTrainingExercise(List<TrainingExerciseResponseDto> dtoList);
}
