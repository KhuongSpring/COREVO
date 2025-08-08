package com.example.corevo.controller;

import com.example.corevo.base.RestApiV1;
import com.example.corevo.base.VsResponseUtil;
import com.example.corevo.constant.UrlConstant;
import com.example.corevo.domain.dto.pagination.PaginationRequestDto;
import com.example.corevo.domain.dto.request.training.ExerciseCompletionRequestDto;
import com.example.corevo.domain.dto.request.training.PersonalTrainingPlanCreationRequestDto;
import com.example.corevo.domain.dto.request.training.TrainingExerciseSearchingRequestDto;
import com.example.corevo.service.TrainingService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

@RestApiV1
@RequiredArgsConstructor
@Validated
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class TrainingController {

    TrainingService trainingService;

    @Tag(name = "training-controller-resource")
    @Operation(
            summary = "Lấy tất cả kế hoạch luyện tập",
            description = "Dùng để lấy tất cả kế hoạch luyện tập",
            security = @SecurityRequirement(name = "Bearer Token")
    )
    @GetMapping(UrlConstant.Training.GET_TRAINING_PLAN)
    public ResponseEntity<?> getTrainingPlans(
            @RequestParam(name = "page num", defaultValue = "1") int PageNum,
            @RequestParam(name = "page size", defaultValue = "1") int PageSize
    ) {
        PaginationRequestDto request = new PaginationRequestDto(PageNum, PageSize);
        return VsResponseUtil.success(trainingService.getTrainingPlans(request));
    }

        @Tag(name = "training-controller-exercise-search")
        @Operation(
                summary = "Tìm kiếm kế hoạch luyện tập theo loại hình",
                description = "Dùng để lấy danh sách kế hoạch luyện tập theo loại hình",
                security = @SecurityRequirement(name = "Bearer Token")
        )
        @GetMapping(UrlConstant.TrainingPlan.GET_BY_TYPE)
        public ResponseEntity<?> getTrainingPlanByType(
                @RequestParam(name = "type") String type,
                @RequestParam(name = "page num", defaultValue = "1") int pageNum,
                @RequestParam(name = "page size", defaultValue = "1") int pageSize
        ) {
                PaginationRequestDto request = new PaginationRequestDto(pageNum, pageSize);
                return VsResponseUtil.success(trainingService.getTrainingPlanByType(type, request));
        }

    @Tag(name = "training-controller-resource")
    @Operation(
            summary = "Lấy tất cả dụng cụ luyện tập",
            description = "Dùng để lấy tất cả dụng cụ luyện tập",
            security = @SecurityRequirement(name = "Bearer Token")
    )
    @GetMapping(UrlConstant.Training.GET_EQUIPMENT)
    public ResponseEntity<?> getEquipments(
            @RequestParam(name = "page num", defaultValue = "1") int PageNum,
            @RequestParam(name = "page size", defaultValue = "1") int PageSize
    ) {
        PaginationRequestDto request = new PaginationRequestDto(PageNum, PageSize);
        return VsResponseUtil.success(trainingService.getEquipments(request));
    }

    @Tag(name = "training-controller-resource")
    @Operation(
            summary = "Lấy tất cả mục tiêu luyện tập",
            description = "Dùng để lấy tất cả mục tiêu luyện tập",
            security = @SecurityRequirement(name = "Bearer Token")
    )
    @GetMapping(UrlConstant.Training.GET_GOAL)
    public ResponseEntity<?> getGoals(
            @RequestParam(name = "page num", defaultValue = "1") int PageNum,
            @RequestParam(name = "page size", defaultValue = "1") int PageSize
    ) {
        PaginationRequestDto request = new PaginationRequestDto(PageNum, PageSize);
        return VsResponseUtil.success(trainingService.getGoals(request));
    }

    @Tag(name = "training-controller-resource")
    @Operation(
            summary = "Lấy tất cả mức độ kinh nghiệm luyện tập",
            description = "Dùng để lấy tất cả mức độ kinh nghiệm luyện tập",
            security = @SecurityRequirement(name = "Bearer Token")
    )
    @GetMapping(UrlConstant.Training.GET_LEVEL)
    public ResponseEntity<?> getLevels(
            @RequestParam(name = "page num", defaultValue = "1") int PageNum,
            @RequestParam(name = "page size", defaultValue = "1") int PageSize
    ) {
        PaginationRequestDto request = new PaginationRequestDto(PageNum, PageSize);
        return VsResponseUtil.success(trainingService.getLevels(request));
    }

    @Tag(name = "training-controller-resource")
    @Operation(
            summary = "Lấy tất cả địa điểm luyện tập",
            description = "Dùng để lấy tất cả địa điểm luyện tập",
            security = @SecurityRequirement(name = "Bearer Token")
    )
    @GetMapping(UrlConstant.Training.GET_LOCATION)
    public ResponseEntity<?> getLocations(
            @RequestParam(name = "page num", defaultValue = "1") int PageNum,
            @RequestParam(name = "page size", defaultValue = "1") int PageSize
    ) {
        PaginationRequestDto request = new PaginationRequestDto(PageNum, PageSize);
        return VsResponseUtil.success(trainingService.getLocations(request));
    }

    @Tag(name = "training-controller-resource")
    @Operation(
            summary = "Lấy tất cả nhóm cơ",
            description = "Dùng để lấy tất cả nhóm cơ",
            security = @SecurityRequirement(name = "Bearer Token")
    )
    @GetMapping(UrlConstant.Training.GET_TARGET_MUSCLE)
    public ResponseEntity<?> getTargetMuscles(
            @RequestParam(name = "page num", defaultValue = "1") int PageNum,
            @RequestParam(name = "page size", defaultValue = "1") int PageSize
    ) {
        PaginationRequestDto request = new PaginationRequestDto(PageNum, PageSize);
        return VsResponseUtil.success(trainingService.getTargetMuscles(request));
    }

    @Tag(name = "training-controller-resource")
    @Operation(
            summary = "Lấy tất cả loại hình luyện tập",
            description = "Dùng để lấy tất cả loại hình luyện tập",
            security = @SecurityRequirement(name = "Bearer Token")
    )
    @GetMapping(UrlConstant.Training.GET_TYPE)
    public ResponseEntity<?> getTypes(
            @RequestParam(name = "page num", defaultValue = "1") int PageNum,
            @RequestParam(name = "page size", defaultValue = "1") int PageSize
    ) {
        PaginationRequestDto request = new PaginationRequestDto(PageNum, PageSize);
        return VsResponseUtil.success(trainingService.getTypes(request));
    }

    @Tag(name = "training-controller-exercise-search")
    @Operation(
            summary = "Lấy tất cả bài tập theo nhóm cơ chính",
            description = "Dùng để lấy tất cả bài tập theo nhóm cơ chính",
            security = @SecurityRequirement(name = "Bearer Token")
    )
    @GetMapping(UrlConstant.Training.GET_EXERCISE_BY_PRIMARY_MUSCLE)
    public ResponseEntity<?> getExerciseByPrimaryMuscle(
            @RequestParam(name = "primary muscle") String primaryMuscle,
            @RequestParam(name = "page num", defaultValue = "1") int PageNum,
            @RequestParam(name = "page size", defaultValue = "1") int PageSize
    ) {
        PaginationRequestDto request = new PaginationRequestDto(PageNum, PageSize);
        return VsResponseUtil.success(trainingService.getPreviewExerciseByPrimaryMuscle(primaryMuscle, request));
    }

    @Tag(name = "training-controller-exercise-search")
    @Operation(
            summary = "Lấy tất cả bài tập theo loại hình luyện tập",
            description = "Dùng để lấy tất cả bài tập theo loại hình luyện tập",
            security = @SecurityRequirement(name = "Bearer Token")
    )
    @GetMapping(UrlConstant.Training.GET_EXERCISE_BY_TYPE)
    public ResponseEntity<?> getExerciseByType(
            @RequestParam(name = "type") String type,
            @RequestParam(name = "page num", defaultValue = "1") int PageNum,
            @RequestParam(name = "page size", defaultValue = "1") int PageSize
    ) {
        PaginationRequestDto request = new PaginationRequestDto(PageNum, PageSize);
        return VsResponseUtil.success(trainingService.getPreviewExerciseByType(type, request));
    }

    @Tag(name = "training-controller-exercise-search")
    @Operation(
            summary = "Lấy tất cả bài tập theo mục tiêu luyện tập",
            description = "Dùng để lấy tất cả bài tập theo mục tiêu luyện tập",
            security = @SecurityRequirement(name = "Bearer Token")
    )
    @GetMapping(UrlConstant.Training.GET_EXERCISE_BY_GOAL)
    public ResponseEntity<?> getExerciseByGoal(
            @RequestParam(name = "goal") String goal,
            @RequestParam(name = "page num", defaultValue = "1") int PageNum,
            @RequestParam(name = "page size", defaultValue = "1") int PageSize
    ) {
        PaginationRequestDto request = new PaginationRequestDto(PageNum, PageSize);
        return VsResponseUtil.success(trainingService.getPreviewExerciseByGoal(goal, request));
    }

    @Tag(name = "training-controller-exercise-search")
    @Operation(
            summary = "Lấy bài tập theo id",
            description = "Dùng để lấy bài tập theo id",
            security = @SecurityRequirement(name = "Bearer Token")
    )
    @GetMapping(UrlConstant.Training.GET_EXERCISE)
    public ResponseEntity<?> getExerciseById(@PathVariable Long id) {
        return VsResponseUtil.success(trainingService.getTrainingExerciseById(id));
    }

    @Tag(name = "training-controller-exercise-search")
    @Operation(
            summary = "Tìm kiếm bài tập",
            description = "Dùng để tìm kiếm tất cả bài tập theo loại và tìm kiếm bài tập",
            security = @SecurityRequirement(name = "Bearer Token")
    )
    @PostMapping(UrlConstant.Training.SEARCH_TRAINING_EXERCISE)
    public ResponseEntity<?> searchExercise(
            @Valid @RequestBody TrainingExerciseSearchingRequestDto searchRequest,
            @RequestParam(name = "page num", defaultValue = "1") int PageNum,
            @RequestParam(name = "page size", defaultValue = "1") int PageSize
    ) {
        PaginationRequestDto request = new PaginationRequestDto(PageNum, PageSize);
        return VsResponseUtil.success(trainingService.searchExercise(searchRequest, request));
    }

    @Tag(name = "training-controller-schedule")
    @Operation(
            summary = "Lấy lịch tập theo kế hoạch tập luyện",
            description = "Dùng để lấy lịch tập theo kế hoạch tập luyện",
            security = @SecurityRequirement(name = "Bearer Token")
    )
    @GetMapping(UrlConstant.Training.GET_TRAINING_SCHEDULE)
    public ResponseEntity<?> getTrainingSchedule(@RequestParam(name = "plan id") Long planId){
        return VsResponseUtil.success(trainingService.getTrainingSchedule(planId));
    }

    @Tag(name = "personal-training-plan")
    @Operation(
            summary = "Tạo kế hoạch tập luyện cá nhân",
            description = "Người dùng tự tạo kế hoạch tập luyện riêng",
            security = @SecurityRequirement(name = "Bearer Token")
    )
    @PostMapping(UrlConstant.TrainingPlan.PERSONAL_PLANS)
    public ResponseEntity<?> createPersonalTrainingPlan(
            @Valid @RequestBody PersonalTrainingPlanCreationRequestDto request,
            Authentication authentication
    ) {
        return VsResponseUtil.success(trainingService.createPersonalTrainingPlan(request, authentication));
    }

    @Tag(name = "personal-training-plan")
    @Operation(
            summary = "Xóa kế hoạch tập luyện cá nhân",
            description = "Xóa kế hoạch tập luyện cá nhân của người dùng",
            security = @SecurityRequirement(name = "Bearer Token")
    )
    @DeleteMapping(UrlConstant.TrainingPlan.PERSONAL_PLANS_BY_ID)
    public ResponseEntity<?> deletePersonalTrainingPlan(
            @PathVariable Long planId,
            Authentication authentication
    ) {
        return VsResponseUtil.success(trainingService.deletePersonalTrainingPlan(planId, authentication));
    }

    @Tag(name = "personal-training-plan")
    @Operation(
            summary = "Lấy danh sách kế hoạch tập luyện cá nhân",
            description = "Lấy tất cả kế hoạch tập luyện cá nhân của người dùng hiện tại",
            security = @SecurityRequirement(name = "Bearer Token")
    )
    @GetMapping(UrlConstant.TrainingPlan.PERSONAL_PLANS)
    public ResponseEntity<?> getUserPersonalTrainingPlans(Authentication authentication) {
        return VsResponseUtil.success(trainingService.getUserPersonalTrainingPlans(authentication));
    }


    @Tag(name = "personal-training-plan")
    @Operation(
            summary = "Lấy bài tập có thể thêm vào training day",
            description = "Lấy danh sách bài tập có thể thêm vào ngày tập luyện",
            security = @SecurityRequirement(name = "Bearer Token")
    )
    @GetMapping(UrlConstant.TrainingPlan.PERSONAL_PLAN_EXERCISES)
    public ResponseEntity<?> getAvailableExercisesForPlan(
            @PathVariable Long planId,
            Authentication authentication
    ) {
        return VsResponseUtil.success(trainingService.getAvailableExercisesForPlan(planId, authentication));
    }

    @Tag(name = "personal-training-plan")
    @Operation(
            summary = "Hoàn thành bài tập trong kế hoạch",
            description = "Đánh dấu hoàn thành một bài tập trong kế hoạch tập luyện cá nhân",
            security = @SecurityRequirement(name = "Bearer Token")
    )
    @PostMapping(UrlConstant.TrainingPlan.PERSONAL_PLAN_COMPLETE_EXERCISE)
    public ResponseEntity<?> completeExerciseForPersonalPlan(
            @PathVariable Long planId,
            @Valid @RequestBody ExerciseCompletionRequestDto request,
            Authentication authentication
    ) {
        return VsResponseUtil.success(trainingService.completeExerciseForPersonalPlan(planId, request, authentication));
    }

    @Tag(name = "personal-training-plan")
    @Operation(
            summary = "Lấy các ngày tập trong kế hoạch",
            description = "Lấy danh sách các ngày tập và tiến độ trong kế hoạch tập luyện cá nhân",
            security = @SecurityRequirement(name = "Bearer Token")
    )
    @GetMapping(UrlConstant.TrainingPlan.PERSONAL_PLAN_DAYS)
    public ResponseEntity<?> getPersonalTrainingDays(
            @PathVariable Long planId,
            Authentication authentication
    ) {
        return VsResponseUtil.success(trainingService.getPersonalTrainingDays(planId, authentication));
    }

}
