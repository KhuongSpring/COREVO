package com.example.corevo.controller;

import com.example.corevo.base.RestApiV1;
import com.example.corevo.base.VsResponseUtil;
import com.example.corevo.constant.SuccessMessage;
import com.example.corevo.constant.UrlConstant;
import com.example.corevo.domain.dto.request.training.ExerciseCompletionRequestDto;
import com.example.corevo.service.TrainingProgressService;
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
public class TrainingProgressController {

    TrainingProgressService trainingProgressService;

    @Tag(name = "training-controller-progress")
    @Operation(
            summary = "Đánh dấu hoàn thành exercise",
            description = "Dùng để người dùng đánh dấu hoàn thành một bài tập",
            security = @SecurityRequirement(name = "Bearer Token")
    )
    @PostMapping(UrlConstant.Training.COMPLETE_EXERCISE)
    public ResponseEntity<?> completeExercise(
            @Valid @RequestBody ExerciseCompletionRequestDto request,
            Authentication authentication
    ) {
        trainingProgressService.completeExercise(request, authentication);
        return VsResponseUtil.success(SuccessMessage.Exercise.COMPLETE_EXERCISE_SUCCESS);
    }

    @Tag(name = "training-controller-progress")
    @Operation(
            summary = "Lấy tiến độ hoàn thành luyện tập theo ngày",
            description = "Dùng để lấy tiến độ hoàn thành luyện tập của user trong ngày hôm nay",
            security = @SecurityRequirement(name = "Bearer Token")
    )
    @GetMapping(UrlConstant.Training.GET_DAILY_PROGRESS)
    public ResponseEntity<?> getDailyProgress(
            Authentication authentication
    ) {
        return VsResponseUtil.success(trainingProgressService.getDailyProgress(authentication));
    }

    @Tag(name = "training-controller-progress")
    @Operation(
            summary = "Lấy tiến độ hoàn thành luyện tập theo tuần",
            description = "Dùng để lấy tiến độ hoàn thành luyện tập của user trong tuần hiện tại",
            security = @SecurityRequirement(name = "Bearer Token")
    )
    @GetMapping(UrlConstant.Training.GET_WEEKLY_PROGRESS)
    public ResponseEntity<?> getWeeklyProgress(
            Authentication authentication
    ) {
        return VsResponseUtil.success(trainingProgressService.getWeeklyProgress(authentication));
    }
}
