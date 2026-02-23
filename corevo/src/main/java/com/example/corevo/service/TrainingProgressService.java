package com.example.corevo.service;

import com.example.corevo.domain.dto.response.training_progress.DailyProgressResponseDto;
import com.example.corevo.domain.dto.response.CommonResponseDto;
import com.example.corevo.domain.dto.response.training_progress.CompletionStatisticResponseDto;
import com.example.corevo.domain.dto.response.training_progress.WeeklyProgressResponseDto;

import java.util.UUID;

public interface TrainingProgressService {

    CommonResponseDto completeExercise(Long exerciseId, UUID userId);

    DailyProgressResponseDto getDailyProgress(UUID userId);

    WeeklyProgressResponseDto getWeeklyProgress(UUID userId);

    CompletionStatisticResponseDto getCompletionStatistic(Integer year, Integer month, UUID userId);

}
