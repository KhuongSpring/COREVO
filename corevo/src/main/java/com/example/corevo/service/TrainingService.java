package com.example.corevo.service;

import com.example.corevo.domain.dto.pagination.PaginationRequestDto;
import com.example.corevo.domain.dto.pagination.PaginationResponseDto;
import com.example.corevo.domain.dto.request.training.TrainingDynamicSearchingRequestDto;
import com.example.corevo.domain.dto.response.training.*;
import com.example.corevo.domain.dto.response.training_exercise.TrainingExerciseLevelPreviewResponseDto;
import com.example.corevo.domain.dto.response.training_exercise.TrainingExercisePreviewResponseDto;
import com.example.corevo.domain.dto.response.training_exercise.TrainingExerciseResponseDto;
import com.example.corevo.domain.dto.response.training_plan.TrainingPlanResponseDto;
import com.example.corevo.domain.dto.response.training_schedule.TrainingScheduleResponseDto;

import java.util.List;

public interface TrainingService {

        PaginationResponseDto<TrainingPlanResponseDto> getTrainingPlans(PaginationRequestDto paginationRequestDto);

        PaginationResponseDto<TrainingPlanResponseDto> getTrainingPlanByType(String type,
                        PaginationRequestDto paginationRequestDto);

        PaginationResponseDto<EquipmentResponseDto> getEquipments(PaginationRequestDto paginationRequestDto);

        PaginationResponseDto<GoalResponseDto> getGoals(PaginationRequestDto paginationRequestDto);

        PaginationResponseDto<LevelResponseDto> getLevels(PaginationRequestDto paginationRequestDto);

        PaginationResponseDto<LocationResponseDto> getLocations(PaginationRequestDto paginationRequestDto);

        PaginationResponseDto<TargetMuscleResponseDto> getTargetMuscles(PaginationRequestDto paginationRequestDto);

        PaginationResponseDto<TypeResponseDto> getTypes(PaginationRequestDto paginationRequestDto);

        TypeResponseDto getTypeById(Long id);

        TargetMuscleResponseDto getTargetMuscleById(Long id);

        TrainingPlanResponseDto getTrainingPlanById(Long id);

        LocationResponseDto getLocationById(Long id);

        LevelResponseDto getLevelById(Long id);

        GoalResponseDto getGoalById(Long id);

        EquipmentResponseDto getEquipmentById(Long id);

        List<TrainingExerciseLevelPreviewResponseDto> getPreviewExerciseByPrimaryMuscle(String primaryMuscle,
                        PaginationRequestDto paginationRequestDto);

        List<TrainingExerciseLevelPreviewResponseDto> getPreviewExerciseByType(String type,
                        PaginationRequestDto paginationRequestDto);

        List<TrainingExerciseLevelPreviewResponseDto> getPreviewExerciseByGoal(String goal,
                        PaginationRequestDto paginationRequestDto);

        TrainingExerciseResponseDto getTrainingExerciseById(Long id);

        List<Long> searchTrainingPlanDynamic(TrainingDynamicSearchingRequestDto request);

        List<TrainingExercisePreviewResponseDto> searchTrainingExerciseDynamic(
                        TrainingDynamicSearchingRequestDto request);

        TrainingScheduleResponseDto getTrainingSchedule(Long planId);

        PaginationResponseDto<TrainingExerciseResponseDto> getAllExercise(PaginationRequestDto paginationRequestDto);

        PaginationResponseDto<TrainingExerciseResponseDto> searchTrainingExercise(
                        String searchRequest,
                        PaginationRequestDto paginationRequestDto);

}
