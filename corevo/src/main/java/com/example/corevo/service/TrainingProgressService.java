package com.example.corevo.service;

import com.example.corevo.domain.dto.request.training.ExerciseCompletionRequestDto;
import com.example.corevo.domain.dto.response.training_progress.DailyProgressResponseDto;
import com.example.corevo.domain.dto.response.training_progress.CompletionStatisticResponseDto;
import com.example.corevo.domain.dto.response.training_progress.WeeklyProgressResponseDto;
import org.springframework.security.core.Authentication;

public interface TrainingProgressService {

    void completeExercise(ExerciseCompletionRequestDto request, Authentication authentication);

    DailyProgressResponseDto getDailyProgress(Authentication authentication);

    WeeklyProgressResponseDto getWeeklyProgress(Authentication authentication);

    CompletionStatisticResponseDto getCompletionStatistic(Integer year, Integer month, Authentication authentication);

}
