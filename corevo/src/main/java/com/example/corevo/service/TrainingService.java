package com.example.corevo.service;

import com.example.corevo.domain.dto.pagination.PaginationRequestDto;
import com.example.corevo.domain.dto.pagination.PaginationResponseDto;
import com.example.corevo.domain.dto.request.training.ExerciseCompletionRequestDto;
import com.example.corevo.domain.dto.request.training.PersonalTrainingPlanCreationRequestDto;
import com.example.corevo.domain.dto.request.training.TrainingExerciseSearchingRequestDto;
import com.example.corevo.domain.dto.response.CommonResponseDto;
import com.example.corevo.domain.dto.response.training.*;
import com.example.corevo.domain.dto.response.training_exercise.TrainingExerciseLevelPreviewResponseDto;
import com.example.corevo.domain.dto.response.training_exercise.TrainingExercisePreviewResponseDto;
import com.example.corevo.domain.dto.response.training_exercise.TrainingExerciseResponseDto;
import com.example.corevo.domain.dto.response.training_plan.PersonalTrainingDayResponseDto;
import com.example.corevo.domain.dto.response.training_plan.PersonalTrainingPlanResponseDto;
import com.example.corevo.domain.dto.response.training_plan.TrainingPlanResponseDto;
import com.example.corevo.domain.dto.response.training_schedule.TrainingScheduleResponseDto;
import org.springframework.security.core.Authentication;

import java.util.List;

public interface TrainingService {

    List<TrainingExerciseLevelPreviewResponseDto> getPreviewExerciseByPrimaryMuscle(String primaryMuscle,
                                                                                    PaginationRequestDto paginationRequestDto);

    List<TrainingExerciseLevelPreviewResponseDto> getPreviewExerciseByType(String type,
                                                                           PaginationRequestDto paginationRequestDto);

    List<TrainingExerciseLevelPreviewResponseDto> getPreviewExerciseByGoal(String goal,
                                                                           PaginationRequestDto paginationRequestDto);

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

    PersonalTrainingPlanResponseDto createPersonalTrainingPlan(
                    PersonalTrainingPlanCreationRequestDto request,
                    Authentication authentication);

    CommonResponseDto deletePersonalTrainingPlan(Long planId, Authentication authentication);

    List<TrainingExerciseResponseDto> getAvailableExercisesForPlan(
                    Long planId,
                    Authentication authentication);

    CommonResponseDto completeExerciseForPersonalPlan(
                    Long planId,
                    ExerciseCompletionRequestDto request,
                    Authentication authentication);

    List<PersonalTrainingDayResponseDto> getPersonalTrainingDays(
                    Long planId,
                    Authentication authentication);

    List<PersonalTrainingPlanResponseDto> getUserPersonalTrainingPlans(Authentication authentication);
}
