package com.example.corevo.service;

import com.example.corevo.domain.dto.pagination.PaginationRequestDto;
import com.example.corevo.domain.dto.pagination.PaginationResponseDto;
import com.example.corevo.domain.dto.request.admin.CreateTrainingExerciseRequestDto;
import com.example.corevo.domain.dto.request.admin.UpdateTrainingExerciseRequestDto;
import com.example.corevo.domain.dto.request.training.TrainingExerciseSearchingRequestDto;
import com.example.corevo.domain.dto.response.CommonResponseDto;
import com.example.corevo.domain.dto.response.training.*;
import com.example.corevo.domain.dto.response.training_exercise.TrainingExerciseLevelPreviewResponseDto;
import com.example.corevo.domain.dto.response.training_exercise.TrainingExercisePreviewResponseDto;
import com.example.corevo.domain.dto.response.training_exercise.TrainingExerciseResponseDto;
import com.example.corevo.domain.dto.response.training_plan.TrainingPlanResponseDto;
import com.example.corevo.domain.dto.response.training_schedule.TrainingScheduleResponseDto;

import java.util.List;

public interface TrainingService {

    List<TrainingExerciseLevelPreviewResponseDto> getPreviewExerciseByPrimaryMuscle(String primaryMuscle,
                                                                                    PaginationRequestDto paginationRequestDto);

    List<TrainingExerciseLevelPreviewResponseDto> getPreviewExerciseByType(String type,
                                                                           PaginationRequestDto paginationRequestDto);

    List<TrainingExerciseLevelPreviewResponseDto> getPreviewExerciseByGoal(String goal,
                                                                           PaginationRequestDto paginationRequestDto);

    PaginationResponseDto<TrainingExerciseResponseDto> getAllExercise(PaginationRequestDto paginationRequestDto);

    PaginationResponseDto<TrainingExercisePreviewResponseDto> searchExercise(TrainingExerciseSearchingRequestDto request,
                                                            PaginationRequestDto paginationRequestDto);

    TrainingExerciseResponseDto getTrainingExerciseById(Long id);

    PaginationResponseDto<TrainingPlanResponseDto> getTrainingPlans(PaginationRequestDto paginationRequestDto);

    PaginationResponseDto<EquipmentResponseDto> getEquipments(PaginationRequestDto paginationRequestDto);

    PaginationResponseDto<GoalResponseDto> getGoals(PaginationRequestDto paginationRequestDto);

    PaginationResponseDto<LevelResponseDto> getLevels(PaginationRequestDto paginationRequestDto);

    PaginationResponseDto<LocationResponseDto> getLocations(PaginationRequestDto paginationRequestDto);

    PaginationResponseDto<TargetMuscleResponseDto> getTargetMuscles(PaginationRequestDto paginationRequestDto);

    PaginationResponseDto<TypeResponseDto> getTypes(PaginationRequestDto paginationRequestDto);

    TrainingScheduleResponseDto getTrainingSchedule(Long planId);

    PaginationResponseDto<TrainingPlanResponseDto> getTrainingPlanByType(String type,
                                                                         PaginationRequestDto paginationRequestDto);

    TrainingExerciseResponseDto creatTrainingExercise(CreateTrainingExerciseRequestDto request);

    TrainingExerciseResponseDto updateTrainingExercise(Long exerciseId,UpdateTrainingExerciseRequestDto request);

    CommonResponseDto deleteTrainingExercise(Long exerciseId);
}
