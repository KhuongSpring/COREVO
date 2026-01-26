package com.example.corevo.controller;

import com.example.corevo.base.RestApiV1;
import com.example.corevo.base.RestData;
import com.example.corevo.base.VsResponseUtil;
import com.example.corevo.constant.UrlConstant;
import com.example.corevo.domain.dto.pagination.PaginationRequestDto;
import com.example.corevo.domain.dto.pagination.PaginationResponseDto;
import com.example.corevo.domain.dto.request.training.TrainingDynamicSearchingRequestDto;
import com.example.corevo.domain.dto.response.training.EquipmentResponseDto;
import com.example.corevo.domain.dto.response.training.GoalResponseDto;
import com.example.corevo.domain.dto.response.training.LevelResponseDto;
import com.example.corevo.domain.dto.response.training.LocationResponseDto;
import com.example.corevo.domain.dto.response.training.TargetMuscleResponseDto;
import com.example.corevo.domain.dto.response.training.TypeResponseDto;
import com.example.corevo.domain.dto.response.training_exercise.TrainingExerciseLevelPreviewResponseDto;
import com.example.corevo.domain.dto.response.training_exercise.TrainingExercisePreviewResponseDto;
import com.example.corevo.domain.dto.response.training_exercise.TrainingExerciseResponseDto;
import com.example.corevo.domain.dto.response.training_plan.TrainingPlanResponseDto;
import com.example.corevo.domain.dto.response.training_schedule.TrainingScheduleResponseDto;
import com.example.corevo.service.TrainingService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

@RestApiV1
@RequiredArgsConstructor
@Validated
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class TrainingController {

        TrainingService trainingService;

        @Tag(name = "training-controller-resource")
        @Operation(summary = "Lấy tất cả kế hoạch luyện tập", description = "Dùng để lấy tất cả kế hoạch luyện tập", security = @SecurityRequirement(name = "Bearer Token"))
        @GetMapping(UrlConstant.Training.GET_TRAINING_PLAN)
        public ResponseEntity<RestData<PaginationResponseDto<TrainingPlanResponseDto>>> getTrainingPlans(
                        @ModelAttribute PaginationRequestDto request) {
                PaginationResponseDto<TrainingPlanResponseDto> response = trainingService.getTrainingPlans(request);
                return VsResponseUtil.success(response);
        }

        @Tag(name = "training-controller-exercise-search")
        @Operation(summary = "Tìm kiếm kế hoạch luyện tập theo loại hình", description = "Dùng để lấy danh sách kế hoạch luyện tập theo loại hình", security = @SecurityRequirement(name = "Bearer Token"))
        @GetMapping(UrlConstant.TrainingPlan.GET_BY_TYPE)
        public ResponseEntity<RestData<PaginationResponseDto<TrainingPlanResponseDto>>> getTrainingPlanByType(
                        @RequestParam(name = "type", required = true) String type,
                        @ModelAttribute PaginationRequestDto request) {
                PaginationResponseDto<TrainingPlanResponseDto> response = trainingService.getTrainingPlanByType(type,
                                request);
                return VsResponseUtil.success(response);
        }

        @Tag(name = "training-controller-resource")
        @Operation(summary = "Lấy tất cả dụng cụ luyện tập", description = "Dùng để lấy tất cả dụng cụ luyện tập", security = @SecurityRequirement(name = "Bearer Token"))
        @GetMapping(UrlConstant.Training.GET_EQUIPMENT)
        public ResponseEntity<RestData<PaginationResponseDto<EquipmentResponseDto>>> getEquipments(
                        @ModelAttribute PaginationRequestDto request) {
                PaginationResponseDto<EquipmentResponseDto> response = trainingService.getEquipments(request);
                return VsResponseUtil.success(response);
        }

        @Tag(name = "training-controller-resource")
        @Operation(summary = "Lấy tất cả mục tiêu luyện tập", description = "Dùng để lấy tất cả mục tiêu luyện tập", security = @SecurityRequirement(name = "Bearer Token"))
        @GetMapping(UrlConstant.Training.GET_GOAL)
        public ResponseEntity<RestData<PaginationResponseDto<GoalResponseDto>>> getGoals(
                        @ModelAttribute PaginationRequestDto request) {
                PaginationResponseDto<GoalResponseDto> response = trainingService.getGoals(request);
                return VsResponseUtil.success(response);
        }

        @Tag(name = "training-controller-resource")
        @Operation(summary = "Lấy tất cả mức độ kinh nghiệm luyện tập", description = "Dùng để lấy tất cả mức độ kinh nghiệm luyện tập", security = @SecurityRequirement(name = "Bearer Token"))
        @GetMapping(UrlConstant.Training.GET_LEVEL)
        public ResponseEntity<RestData<PaginationResponseDto<LevelResponseDto>>> getLevels(
                        @ModelAttribute PaginationRequestDto request) {
                PaginationResponseDto<LevelResponseDto> response = trainingService.getLevels(request);
                return VsResponseUtil.success(response);
        }

        @Tag(name = "training-controller-resource")
        @Operation(summary = "Lấy tất cả địa điểm luyện tập", description = "Dùng để lấy tất cả địa điểm luyện tập", security = @SecurityRequirement(name = "Bearer Token"))
        @GetMapping(UrlConstant.Training.GET_LOCATION)
        public ResponseEntity<RestData<PaginationResponseDto<LocationResponseDto>>> getLocations(
                        @ModelAttribute PaginationRequestDto request) {
                PaginationResponseDto<LocationResponseDto> response = trainingService.getLocations(request);
                return VsResponseUtil.success(response);
        }

        @Tag(name = "training-controller-resource")
        @Operation(summary = "Lấy tất cả nhóm cơ", description = "Dùng để lấy tất cả nhóm cơ", security = @SecurityRequirement(name = "Bearer Token"))
        @GetMapping(UrlConstant.Training.GET_TARGET_MUSCLE)
        public ResponseEntity<RestData<PaginationResponseDto<TargetMuscleResponseDto>>> getTargetMuscles(
                        @ModelAttribute PaginationRequestDto request) {
                PaginationResponseDto<TargetMuscleResponseDto> response = trainingService.getTargetMuscles(request);
                return VsResponseUtil.success(response);
        }

        @Tag(name = "training-controller-resource")
        @Operation(summary = "Lấy tất cả loại hình luyện tập", description = "Dùng để lấy tất cả loại hình luyện tập", security = @SecurityRequirement(name = "Bearer Token"))
        @GetMapping(UrlConstant.Training.GET_TYPE)
        public ResponseEntity<RestData<PaginationResponseDto<TypeResponseDto>>> getTypes(
                        @ModelAttribute PaginationRequestDto request) {
                PaginationResponseDto<TypeResponseDto> response = trainingService.getTypes(request);
                return VsResponseUtil.success(response);
        }

        @Tag(name = "training-controller-resource")
        @Operation(summary = "Lấy loại hình luyện tập theo id", description = "Dùng để lấy loại hình luyện tập theo id", security = @SecurityRequirement(name = "Bearer Token"))
        @GetMapping(UrlConstant.Training.GET_TYPE_BY_ID)
        public ResponseEntity<RestData<TypeResponseDto>> getTypeById(@PathVariable Long id) {
                TypeResponseDto response = trainingService.getTypeById(id);
                return VsResponseUtil.success(response);
        }

        @Tag(name = "training-controller-resource")
        @Operation(summary = "Lấy nhóm cơ theo id", description = "Dùng để lấy nhóm cơ theo id", security = @SecurityRequirement(name = "Bearer Token"))
        @GetMapping(UrlConstant.Training.GET_TARGET_MUSCLE_BY_ID)
        public ResponseEntity<RestData<TargetMuscleResponseDto>> getTargetMuscleById(@PathVariable Long id) {
                TargetMuscleResponseDto response = trainingService.getTargetMuscleById(id);
                return VsResponseUtil.success(response);
        }

        @Tag(name = "training-controller-resource")
        @Operation(summary = "Lấy kế hoạch luyện tập theo id", description = "Dùng để lấy kế hoạch luyện tập theo id", security = @SecurityRequirement(name = "Bearer Token"))
        @GetMapping(UrlConstant.Training.GET_TRAINING_PLAN_BY_ID)
        public ResponseEntity<RestData<TrainingPlanResponseDto>> getTrainingPlanById(@PathVariable Long id) {
                TrainingPlanResponseDto response = trainingService.getTrainingPlanById(id);
                return VsResponseUtil.success(response);
        }

        @Tag(name = "training-controller-resource")
        @Operation(summary = "Lấy địa điểm luyện tập theo id", description = "Dùng để lấy địa điểm luyện tập theo id", security = @SecurityRequirement(name = "Bearer Token"))
        @GetMapping(UrlConstant.Training.GET_LOCATION_BY_ID)
        public ResponseEntity<RestData<LocationResponseDto>> getLocationById(@PathVariable Long id) {
                LocationResponseDto response = trainingService.getLocationById(id);
                return VsResponseUtil.success(response);
        }

        @Tag(name = "training-controller-resource")
        @Operation(summary = "Lấy mức độ kinh nghiệm luyện tập theo id", description = "Dùng để lấy mức độ kinh nghiệm luyện tập theo id", security = @SecurityRequirement(name = "Bearer Token"))
        @GetMapping(UrlConstant.Training.GET_LEVEL_BY_ID)
        public ResponseEntity<RestData<LevelResponseDto>> getLevelById(@PathVariable Long id) {
                LevelResponseDto response = trainingService.getLevelById(id);
                return VsResponseUtil.success(response);
        }

        @Tag(name = "training-controller-resource")
        @Operation(summary = "Lấy mục tiêu luyện tập theo id", description = "Dùng để lấy mục tiêu luyện tập theo id", security = @SecurityRequirement(name = "Bearer Token"))
        @GetMapping(UrlConstant.Training.GET_GOAL_BY_ID)
        public ResponseEntity<RestData<GoalResponseDto>> getGoalById(@PathVariable Long id) {
                GoalResponseDto response = trainingService.getGoalById(id);
                return VsResponseUtil.success(response);
        }

        @Tag(name = "training-controller-resource")
        @Operation(summary = "Lấy dụng cụ luyện tập theo id", description = "Dùng để lấy dụng cụ luyện tập theo id", security = @SecurityRequirement(name = "Bearer Token"))
        @GetMapping(UrlConstant.Training.GET_EQUIPMENT_BY_ID)
        public ResponseEntity<RestData<EquipmentResponseDto>> getEquipmentById(@PathVariable Long id) {
                EquipmentResponseDto response = trainingService.getEquipmentById(id);
                return VsResponseUtil.success(response);
        }

        @Tag(name = "training-controller-exercise-search")
        @Operation(summary = "Lấy tất cả bài tập theo nhóm cơ chính", description = "Dùng để lấy tất cả bài tập theo nhóm cơ chính", security = @SecurityRequirement(name = "Bearer Token"))
        @GetMapping(UrlConstant.Training.GET_EXERCISE_BY_PRIMARY_MUSCLE)
        public ResponseEntity<RestData<List<TrainingExerciseLevelPreviewResponseDto>>> getExerciseByPrimaryMuscle(
                        @RequestParam(name = "primaryMuscle", required = true) String primaryMuscle,
                        @ModelAttribute PaginationRequestDto request) {
                List<TrainingExerciseLevelPreviewResponseDto> response = trainingService
                                .getPreviewExerciseByPrimaryMuscle(primaryMuscle, request);
                return VsResponseUtil.success(response);
        }

        @Tag(name = "training-controller-exercise-search")
        @Operation(summary = "Lấy tất cả bài tập theo loại hình luyện tập", description = "Dùng để lấy tất cả bài tập theo loại hình luyện tập", security = @SecurityRequirement(name = "Bearer Token"))
        @GetMapping(UrlConstant.Training.GET_EXERCISE_BY_TYPE)
        public ResponseEntity<RestData<List<TrainingExerciseLevelPreviewResponseDto>>> getExerciseByType(
                        @RequestParam(name = "type", required = true) String type,
                        @ModelAttribute PaginationRequestDto request) {
                List<TrainingExerciseLevelPreviewResponseDto> response = trainingService
                                .getPreviewExerciseByType(type, request);
                return VsResponseUtil.success(response);
        }

        @Tag(name = "training-controller-exercise-search")
        @Operation(summary = "Lấy tất cả bài tập theo mục tiêu luyện tập", description = "Dùng để lấy tất cả bài tập theo mục tiêu luyện tập", security = @SecurityRequirement(name = "Bearer Token"))
        @GetMapping(UrlConstant.Training.GET_EXERCISE_BY_GOAL)
        public ResponseEntity<RestData<List<TrainingExerciseLevelPreviewResponseDto>>> getExerciseByGoal(
                        @RequestParam(name = "goal", required = true) String goal,
                        @ModelAttribute PaginationRequestDto request) {
                List<TrainingExerciseLevelPreviewResponseDto> response = trainingService
                                .getPreviewExerciseByGoal(goal, request);
                return VsResponseUtil.success(response);
        }

        @Tag(name = "training-controller-exercise-search")
        @Operation(summary = "Lấy bài tập theo id", description = "Dùng để lấy bài tập theo id", security = @SecurityRequirement(name = "Bearer Token"))
        @GetMapping(UrlConstant.Training.GET_EXERCISE)
        public ResponseEntity<RestData<TrainingExerciseResponseDto>> getExerciseById(@PathVariable Long id) {
                TrainingExerciseResponseDto response = trainingService.getTrainingExerciseById(id);
                return VsResponseUtil.success(response);
        }

        @Tag(name = "training-controller-exercise-search")
        @Operation(summary = "Tìm kiếm kế hoạch luyện tập", description = "Dùng để tìm kiếm tất cả kế hoạch luyện tập theo mong muốn", security = @SecurityRequirement(name = "Bearer Token"))
        @PostMapping(UrlConstant.Training.SEARCH_TRAINING_PLAN_DYNAMIC)
        public ResponseEntity<RestData<List<Long>>> searchTrainingPlanDynamic(
                        @Valid @RequestBody TrainingDynamicSearchingRequestDto request) {
                List<Long> response = trainingService.searchTrainingPlanDynamic(request);
                return VsResponseUtil.success(response);
        }

        @Tag(name = "training-controller-exercise-search")
        @Operation(summary = "Tìm kiếm bài tập", description = "Dùng để tìm kiếm tất cả bài tập theo mong muốn", security = @SecurityRequirement(name = "Bearer Token"))
        @PostMapping(UrlConstant.Training.SEARCH_TRAINING_EXERCISE_DYNAMIC)
        public ResponseEntity<RestData<List<TrainingExercisePreviewResponseDto>>> searchTrainingExerciseDynamic(
                        @Valid @RequestBody TrainingDynamicSearchingRequestDto request) {
                List<TrainingExercisePreviewResponseDto> response = trainingService
                                .searchTrainingExerciseDynamic(request);
                return VsResponseUtil.success(response);
        }

        @Tag(name = "training-controller-schedule")
        @Operation(summary = "Lấy lịch tập theo kế hoạch tập luyện", description = "Dùng để lấy lịch tập theo kế hoạch tập luyện", security = @SecurityRequirement(name = "Bearer Token"))
        @GetMapping(UrlConstant.Training.GET_TRAINING_SCHEDULE)
        public ResponseEntity<RestData<TrainingScheduleResponseDto>> getTrainingSchedule(
                        @RequestParam(name = "planId") Long planId) {
                TrainingScheduleResponseDto response = trainingService.getTrainingSchedule(planId);
                return VsResponseUtil.success(response);
        }

        // //
        // Methods for ADMIN //
        // //

        @Tag(name = "admin-controller")
        @Operation(summary = "Lấy tất cả bài tập ", description = "Dùng để lấy tất cả bài tập", security = @SecurityRequirement(name = "Bearer Token"))
        @GetMapping(UrlConstant.Admin.GET_ALL_EXERCISE)
        public ResponseEntity<RestData<PaginationResponseDto<TrainingExerciseResponseDto>>> getAllExercises(
                        @ModelAttribute PaginationRequestDto request) {
                PaginationResponseDto<TrainingExerciseResponseDto> response = trainingService.getAllExercise(request);
                return VsResponseUtil.success(response);
        }

        @Tag(name = "admin-controller")
        @Operation(summary = "Tìm kiếm bài tập", description = "Dùng để tìm kiếm tất cả bài tập theo từ khóa tìm kiếm", security = @SecurityRequirement(name = "Bearer Token"))
        @GetMapping(UrlConstant.Admin.SEARCH_TRAINING_EXERCISE)
        public ResponseEntity<RestData<PaginationResponseDto<TrainingExerciseResponseDto>>> searchTrainingExercise(
                        @RequestParam(required = true) String searchRequest,
                        @ModelAttribute PaginationRequestDto request) {
                PaginationResponseDto<TrainingExerciseResponseDto> response = trainingService
                                .searchTrainingExercise(searchRequest, request);
                return VsResponseUtil.success(response);
        }
}
