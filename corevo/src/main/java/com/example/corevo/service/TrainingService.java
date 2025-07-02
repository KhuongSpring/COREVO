package com.example.corevo.service;

import com.example.corevo.domain.dto.response.training.*;
import com.example.corevo.domain.dto.response.training_exercise.TrainingExerciseLevelPreviewResponseDto;
import com.example.corevo.domain.dto.response.training_exercise.TrainingExerciseResponseDto;

import java.util.List;

public interface TrainingService {

    List<TrainingExerciseLevelPreviewResponseDto> getPreviewExerciseByPrimaryMuscle(String primaryMuscle);

    List<TrainingExerciseLevelPreviewResponseDto> getPreviewExerciseByType(String type);

    List<TrainingExerciseLevelPreviewResponseDto> getPreviewExerciseByGoal(String goal);

    TrainingExerciseResponseDto getTrainingExerciseById(Long id);

    List<EquipmentResponseDto> getEquipments();

    List<GoalResponseDto> getGoals();

    List<LevelResponseDto> getLevels();

    List<LocationResponseDto> getLocations();

    List<TargetMuscleResponseDto> getTargetMuscles();

    List<TypeResponseDto> getTypes();

}
