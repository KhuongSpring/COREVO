package com.example.corevo.domain.mapper;

import com.example.corevo.domain.dto.response.training_exercise.TrainingExerciseLevelPreviewResponseDto;
import com.example.corevo.domain.dto.response.training_exercise.TrainingExercisePreviewResponseDto;
import com.example.corevo.domain.dto.response.training_exercise.TrainingExerciseResponseDto;
import com.example.corevo.domain.entity.training.TrainingExercise;
import com.example.corevo.helper.training_helper.TrainingMapperHelper;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.NullValueCheckStrategy;
import org.mapstruct.NullValuePropertyMappingStrategy;

import java.util.List;

@Mapper(componentModel = "spring",
        uses = TrainingMapperHelper.class,
        nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE,
        nullValueCheckStrategy = NullValueCheckStrategy.ALWAYS
)
public interface TrainingExerciseMapper {
    @Mapping(target = "levels", source = "levelIds", qualifiedByName = "mapLevelToEntity")
    @Mapping(target = "types", source = "typeIds", qualifiedByName = "mapTypeToEntity")
    @Mapping(target = "primaryMuscles", source = "primaryMuscleIds", qualifiedByName = "mapTargetMuscleToEntity")
    @Mapping(target = "secondaryMuscles", source = "secondaryMuscleIds", qualifiedByName = "mapTargetMuscleToEntity")
    @Mapping(target = "equipments", source = "equipmentIds", qualifiedByName = "mapEquipmentToEntity")
    @Mapping(target = "locations", source = "locationIds", qualifiedByName = "mapLocationToEntity")
    @Mapping(target = "goals", source = "goalIds", qualifiedByName = "mapGoalToEntity")
    TrainingExercise trainingExerciseResponseDtoToTrainingExercise(TrainingExerciseResponseDto dto);

    List<TrainingExercise> listTrainingExerciseResponseDtoToListTrainingExercise(List<TrainingExerciseResponseDto> dtoList);

    @Mapping(target = "levelIds", source = "levels", qualifiedByName = "mapLevelToId")
    @Mapping(target = "typeIds", source = "types", qualifiedByName = "mapTypeToId")
    @Mapping(target = "primaryMuscleIds", source = "primaryMuscles", qualifiedByName = "mapTargetMuscleToId")
    @Mapping(target = "secondaryMuscleIds", source = "secondaryMuscles", qualifiedByName = "mapTargetMuscleToId")
    @Mapping(target = "equipmentIds", source = "equipments", qualifiedByName = "mapEquipmentToId")
    @Mapping(target = "locationIds", source = "locations", qualifiedByName = "mapLocationToId")
    @Mapping(target = "goalIds", source = "goals", qualifiedByName = "mapGoalToId")
    TrainingExerciseResponseDto trainingExerciseToTrainingExerciseResponseDto(TrainingExercise exercise);

    List<TrainingExerciseResponseDto> listTrainingExerciseToListTrainingExerciseResponseDto(List<TrainingExercise> exercises);

    TrainingExercisePreviewResponseDto trainingExerciseToTrainingExercisePreviewResponseDto(TrainingExercise exercise);

    List<TrainingExercisePreviewResponseDto> listTrainingExerciseToListTrainingExercisePreviewResponseDto(List<TrainingExercise> exercises);

}
