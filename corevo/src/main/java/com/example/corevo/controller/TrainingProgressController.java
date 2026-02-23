package com.example.corevo.controller;

import com.example.corevo.base.RestApiV1;
import com.example.corevo.base.RestData;
import com.example.corevo.base.VsResponseUtil;
import com.example.corevo.constant.UrlConstant;
import com.example.corevo.domain.dto.response.CommonResponseDto;
import com.example.corevo.domain.dto.response.training_progress.CompletionStatisticResponseDto;
import com.example.corevo.domain.dto.response.training_progress.DailyProgressResponseDto;
import com.example.corevo.domain.dto.response.training_progress.WeeklyProgressResponseDto;
import com.example.corevo.security.SecurityUtils;
import com.example.corevo.service.TrainingProgressService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;

import java.util.UUID;

import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

@RestApiV1
@RequiredArgsConstructor
@Validated
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class TrainingProgressController {

        TrainingProgressService trainingProgressService;

        @Tag(name = "training-controller-progress")
        @Operation(summary = "Đánh dấu hoàn thành exercise", description = "Dùng để người dùng đánh dấu hoàn thành một bài tập", security = @SecurityRequirement(name = "Bearer Token"))
        @PostMapping(UrlConstant.Training.COMPLETE_EXERCISE)
        public ResponseEntity<RestData<CommonResponseDto>> completeExercise(
                        @RequestParam(name = "exerciseId", required = true) Long exerciseId) {
                UUID userId = SecurityUtils.getCurrentUserId();
                CommonResponseDto response = trainingProgressService.completeExercise(exerciseId, userId);
                return VsResponseUtil.success(response);
        }

        @Tag(name = "training-controller-progress")
        @Operation(summary = "Lấy tiến độ hoàn thành luyện tập theo ngày", description = "Dùng để lấy tiến độ hoàn thành luyện tập của user trong ngày hôm nay", security = @SecurityRequirement(name = "Bearer Token"))
        @GetMapping(UrlConstant.Training.GET_DAILY_PROGRESS)
        public ResponseEntity<RestData<DailyProgressResponseDto>> getDailyProgress() {
                UUID userId = SecurityUtils.getCurrentUserId();
                DailyProgressResponseDto response = trainingProgressService.getDailyProgress(userId);
                return VsResponseUtil.success(response);
        }

        @Tag(name = "training-controller-progress")
        @Operation(summary = "Lấy tiến độ hoàn thành luyện tập theo tuần", description = "Dùng để lấy tiến độ hoàn thành luyện tập của user trong tuần hiện tại", security = @SecurityRequirement(name = "Bearer Token"))
        @GetMapping(UrlConstant.Training.GET_WEEKLY_PROGRESS)
        public ResponseEntity<RestData<WeeklyProgressResponseDto>> getWeeklyProgress() {
                UUID userId = SecurityUtils.getCurrentUserId();
                WeeklyProgressResponseDto response = trainingProgressService.getWeeklyProgress(userId);
                return VsResponseUtil.success(response);
        }

        @Tag(name = "training-controller-progress")
        @Operation(summary = "Lấy các thông tin thống kê luyện tập", description = "Dùng để lấy các thông tin thống kê luyện tập của nguời dùng hiện tại", security = @SecurityRequirement(name = "Bearer Token"))
        @GetMapping(UrlConstant.Training.GET_COMPLETED_STATISTIC)
        public ResponseEntity<RestData<CompletionStatisticResponseDto>> getCompletionCalendar(
                        @RequestParam(required = false) Integer year,
                        @RequestParam(required = false) Integer month) {
                UUID userId = SecurityUtils.getCurrentUserId();
                CompletionStatisticResponseDto response = trainingProgressService.getCompletionStatistic(year, month,
                                userId);
                return VsResponseUtil.success(response);
        }
}
