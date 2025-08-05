package com.example.corevo.domain.mapper;

import com.example.corevo.domain.dto.request.admin.CreateTrainingExerciseRequestDto;
import com.example.corevo.domain.dto.request.admin.UpdateTrainingExerciseRequestDto;
import com.example.corevo.domain.dto.response.training_exercise.TrainingExercisePreviewResponseDto;
import com.example.corevo.domain.dto.response.training_exercise.TrainingExerciseResponseDto;
import com.example.corevo.domain.entity.training.TrainingExercise;
import com.example.corevo.helper.training_helper.TrainingMapperHelper;
import org.mapstruct.*;

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

    @Mapping(target = "levels", source = "levelIds")
    @Mapping(target = "types", source = "typeIds")
    @Mapping(target = "primaryMuscles", source = "primaryMuscleIds")
    @Mapping(target = "secondaryMuscles", source = "secondaryMuscleIds")
    @Mapping(target = "equipments", source = "equipmentIds")
    @Mapping(target = "locations", source = "locationIds")
    @Mapping(target = "goals", source = "goalIds")
    TrainingExercise createTrainingExercise(CreateTrainingExerciseRequestDto requestDto);


    @Mapping(target = "levels", source = "levelIds")
    @Mapping(target = "types", source = "typeIds")
    @Mapping(target = "primaryMuscles", source = "primaryMuscleIds")
    @Mapping(target = "secondaryMuscles", source = "secondaryMuscleIds")
    @Mapping(target = "equipments", source = "equipmentIds")
    @Mapping(target = "locations", source = "locationIds")
    @Mapping(target = "goals", source = "goalIds")
    void updateTrainingExerciseFromDto(UpdateTrainingExerciseRequestDto requestDto,@MappingTarget TrainingExercise trainingExercise);

}
