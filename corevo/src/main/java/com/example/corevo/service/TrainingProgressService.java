package com.example.corevo.service;

import com.example.corevo.domain.dto.response.training_progress.DailyProgressResponseDto;
import com.example.corevo.domain.dto.response.CommonResponseDto;
import com.example.corevo.domain.dto.response.training_progress.CompletionStatisticResponseDto;
import com.example.corevo.domain.dto.response.training_progress.WeeklyProgressResponseDto;
import org.springframework.security.core.Authentication;

public interface TrainingProgressService {

    CommonResponseDto completeExercise(Long exerciseId, Authentication authentication);

    DailyProgressResponseDto getDailyProgress(Authentication authentication);

    WeeklyProgressResponseDto getWeeklyProgress(Authentication authentication);

    CompletionStatisticResponseDto getCompletionStatistic(Integer year, Integer month, Authentication authentication);

}
