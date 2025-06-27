package com.example.corevo.service;

import com.example.corevo.domain.dto.request.training.TrainingExerciseSearchingRequestDto;
import com.example.corevo.domain.dto.response.training_exercise.TrainingExerciseSearchResultResponseDto;

public interface TrainingExerciseSearchingService {
    TrainingExerciseSearchResultResponseDto<?> searchHandle(
            TrainingExerciseSearchingRequestDto request);
}
