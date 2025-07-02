package com.example.corevo.controller;

import com.example.corevo.base.RestApiV1;
import com.example.corevo.base.VsResponseUtil;
import com.example.corevo.constant.UrlConstant;
import com.example.corevo.service.TrainingService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

@RestApiV1
@RequiredArgsConstructor
@Validated
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class TrainingController {

    TrainingService trainingService;

    @Operation(
            summary = "Lấy tất cả dụng cụ luyện tập",
            description = "Dùng để lấy tất cả dụng cụ luyện tập",
            security = @SecurityRequirement(name = "Bearer Token")
    )
    @PostMapping(UrlConstant.Training.GET_EQUIPMENT)
    public ResponseEntity<?> getEquipments() {
        return VsResponseUtil.success(trainingService.getEquipments());
    }

    @Operation(
            summary = "Lấy tất cả mục tiêu luyện tập",
            description = "Dùng để lấy tất cả mục tiêu luyện tập",
            security = @SecurityRequirement(name = "Bearer Token")
    )
    @PostMapping(UrlConstant.Training.GET_GOAL)
    public ResponseEntity<?> getGoals() {
        return VsResponseUtil.success(trainingService.getGoals());
    }

    @Operation(
            summary = "Lấy tất cả mức độ kinh nghiệm luyện tập",
            description = "Dùng để lấy tất cả mức độ kinh nghiệm luyện tập",
            security = @SecurityRequirement(name = "Bearer Token")
    )
    @PostMapping(UrlConstant.Training.GET_LEVEL)
    public ResponseEntity<?> getLevels() {
        return VsResponseUtil.success(trainingService.getLevels());
    }

    @Operation(
            summary = "Lấy tất cả địa điểm luyện tập",
            description = "Dùng để lấy tất cả địa điểm luyện tập",
            security = @SecurityRequirement(name = "Bearer Token")
    )
    @PostMapping(UrlConstant.Training.GET_LOCATION)
    public ResponseEntity<?> getLocations() {
        return VsResponseUtil.success(trainingService.getLocations());
    }

    @Operation(
            summary = "Lấy tất cả nhóm cơ",
            description = "Dùng để lấy tất cả nhóm cơ",
            security = @SecurityRequirement(name = "Bearer Token")
    )
    @PostMapping(UrlConstant.Training.GET_TARGET_MUSCLE)
    public ResponseEntity<?> getTargetMuscles() {
        return VsResponseUtil.success(trainingService.getTargetMuscles());
    }

    @Operation(
            summary = "Lấy tất cả loại hình luyện tập",
            description = "Dùng để lấy tất cả loại hình luyện tập",
            security = @SecurityRequirement(name = "Bearer Token")
    )
    @PostMapping(UrlConstant.Training.GET_TYPE)
    public ResponseEntity<?> getTypes() {
        return VsResponseUtil.success(trainingService.getTypes());
    }

    @Operation(
            summary = "Lấy tất cả bài tập theo nhóm nhóm cơ chính",
            description = "Dùng để lấy tất cả bài tập theo nhóm cơ chính",
            security = @SecurityRequirement(name = "Bearer Token")
    )
    @PostMapping(UrlConstant.Training.GET_EXERCISE_BY_PRIMARY_MUSCLE)
    public ResponseEntity<?> getExerciseByPrimaryMuscle(
            @RequestParam(name = "primaryMuscle") String primaryMuscle
    ) {
        return VsResponseUtil.success(trainingService.getPreviewExerciseByPrimaryMuscle(primaryMuscle));
    }

    @Operation(
            summary = "Lấy tất cả bài tập theo loại hình luyện tập",
            description = "Dùng để lấy tất cả bài tập theo loại hình luyện tập",
            security = @SecurityRequirement(name = "Bearer Token")
    )
    @PostMapping(UrlConstant.Training.GET_EXERCISE_BY_TYPE)
    public ResponseEntity<?> getExerciseByType(
            @RequestParam(name = "type") String type
    ) {
        return VsResponseUtil.success(trainingService.getPreviewExerciseByType(type));
    }

    @Operation(
            summary = "Lấy tất cả bài tập theo mục tiêu luyện tập",
            description = "Dùng để lấy tất cả bài tập theo mục tiêu luyện tập",
            security = @SecurityRequirement(name = "Bearer Token")
    )
    @PostMapping(UrlConstant.Training.GET_EXERCISE_BY_GOAL)
    public ResponseEntity<?> getExerciseByGoal(
            @RequestParam(name = "goal") String goal
    ) {
        return VsResponseUtil.success(trainingService.getPreviewExerciseByGoal(goal));
    }

    @Operation(
            summary = "Lấy bài tập theo id",
            description = "Dùng để lấy bài tập theo id",
            security = @SecurityRequirement(name = "Bearer Token")
    )
    @GetMapping(UrlConstant.Training.GET_EXERCISE)
    public ResponseEntity<?> getExerciseById(@PathVariable Long id) {
        return VsResponseUtil.success(trainingService.getTrainingExerciseById(id));
    }

//    @Operation(
//            summary = "Lấy bài tập",
//            description = "Dùng để lấy tất cả bài tập theo loại và tìm kiếm bài tập",
//            security = @SecurityRequirement(name = "Bearer Token")
//    )
//    @PostMapping(UrlConstant.Training.SEARCH_TRAINING_EXERCISE)
//    public ResponseEntity<?> searchExercise(@Valid @RequestBody TrainingExerciseSearchingRequestDto request){
//        return VsResponseUtil.success(HttpStatus.OK, trainingService.searchHandle(request));
//    }

}
