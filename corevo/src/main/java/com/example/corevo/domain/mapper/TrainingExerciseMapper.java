package com.example.corevo.domain.mapper;

import com.example.corevo.domain.dto.response.training_exercise.TrainingExercisePreviewResponseDto;
import com.example.corevo.domain.dto.response.training_exercise.TrainingExerciseResponseDto;
import com.example.corevo.domain.entity.training.TrainingExercise;
import com.example.corevo.domain.entity.training.*;
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
    @Mapping(target = "levels", source = "levelIds")
    @Mapping(target = "types", source = "typeIds")
    @Mapping(target = "primaryMuscles", source = "primaryMuscleIds")
    @Mapping(target = "secondaryMuscles", source = "secondaryMuscleIds")
    @Mapping(target = "equipments", source = "equipmentIds")
    @Mapping(target = "locations", source = "locationIds")
    @Mapping(target = "goals", source = "goalIds")
    TrainingExercise trainingExerciseResponseDtoToTrainingExercise(TrainingExerciseResponseDto dto);

    List<TrainingExercise> listTrainingExerciseResponseDtoToListTrainingExercise(List<TrainingExerciseResponseDto> dtoList);

    @Mapping(target = "levelIds", source = "levels")
    @Mapping(target = "typeIds", source = "types")
    @Mapping(target = "primaryMuscleIds", source = "primaryMuscles")
    @Mapping(target = "secondaryMuscleIds", source = "secondaryMuscles")
    @Mapping(target = "equipmentIds", source = "equipments")
    @Mapping(target = "locationIds", source = "locations")
    @Mapping(target = "goalIds", source = "goals")
    TrainingExerciseResponseDto trainingExerciseToTrainingExerciseResponseDto(TrainingExercise exercise);

    List<TrainingExerciseResponseDto> listTrainingExerciseToListTrainingExerciseResponseDto(List<TrainingExercise> exercises);

    TrainingExercisePreviewResponseDto trainingExerciseToTrainingExercisePreviewResponseDto(TrainingExercise exercise);

    List<TrainingExercisePreviewResponseDto> listTrainingExerciseToListTrainingExercisePreviewResponseDto(List<TrainingExercise> exercises);

    default List<Long> mapLevelsToIds(List<Level> levels) {
        return levels == null ? null : levels.stream().map(Level::getId).toList();
    }

    default List<Long> mapTypesToIds(List<Type> types) {
        return types == null ? null : types.stream().map(Type::getId).toList();
    }

    default List<Long> mapTargetMusclesToIds(List<TargetMuscle> muscles) {
        return muscles == null ? null : muscles.stream().map(TargetMuscle::getId).toList();
    }

    default List<Long> mapEquipmentsToIds(List<Equipment> list) {
        return list == null ? null : list.stream().map(Equipment::getId).toList();
    }

    default List<Long> mapLocationsToIds(List<Location> list) {
        return list == null ? null : list.stream().map(Location::getId).toList();
    }

    default List<Long> mapGoalsToIds(List<Goal> list) {
        return list == null ? null : list.stream().map(Goal::getId).toList();
    }

}
