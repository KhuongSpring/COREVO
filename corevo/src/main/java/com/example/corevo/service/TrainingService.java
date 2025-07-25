package com.example.corevo.service;

import com.example.corevo.domain.dto.request.training.TrainingExerciseSearchingRequestDto;
import com.example.corevo.domain.dto.response.training.*;
import com.example.corevo.domain.dto.response.training_exercise.TrainingExerciseLevelPreviewResponseDto;
import com.example.corevo.domain.dto.response.training_exercise.TrainingExercisePreviewResponseDto;
import com.example.corevo.domain.dto.response.training_exercise.TrainingExerciseResponseDto;
import com.example.corevo.domain.dto.response.training_plan.TrainingPlanResponseDto;
import com.example.corevo.domain.dto.response.training_schedule.TrainingScheduleResponseDto;

import java.util.List;

public interface TrainingService {

    List<TrainingExerciseLevelPreviewResponseDto> getPreviewExerciseByPrimaryMuscle(String primaryMuscle);

    List<TrainingExerciseLevelPreviewResponseDto> getPreviewExerciseByType(String type);

    List<TrainingExerciseLevelPreviewResponseDto> getPreviewExerciseByGoal(String goal);

    List<TrainingExercisePreviewResponseDto> searchExercise(TrainingExerciseSearchingRequestDto request);

    TrainingExerciseResponseDto getTrainingExerciseById(Long id);

    List<TrainingPlanResponseDto> getTrainingPlans();

    List<EquipmentResponseDto> getEquipments();

    List<GoalResponseDto> getGoals();

    List<LevelResponseDto> getLevels();

    List<LocationResponseDto> getLocations();

    List<TargetMuscleResponseDto> getTargetMuscles();

    List<TypeResponseDto> getTypes();

    TrainingScheduleResponseDto getTrainingSchedule(Long planId);

}
