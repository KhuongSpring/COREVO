package com.example.corevo.service.impl;

import com.example.corevo.domain.dto.request.training.TrainingExerciseSearchingRequestDto;
import com.example.corevo.domain.dto.response.training.GoalResponseDto;
import com.example.corevo.domain.dto.response.training.LevelResponseDto;
import com.example.corevo.domain.dto.response.training.TargetMuscleResponseDto;
import com.example.corevo.domain.dto.response.training.TypeResponseDto;
import com.example.corevo.domain.dto.response.training_exercise.TrainingExerciseSearchResultResponseDto;
import com.example.corevo.domain.entity.training.Goal;
import com.example.corevo.domain.entity.training.Level;
import com.example.corevo.domain.entity.training.TargetMuscle;
import com.example.corevo.domain.entity.training.Type;
import com.example.corevo.repository.GoalRepository;
import com.example.corevo.repository.LevelRepository;
import com.example.corevo.repository.TargetMuscleRepository;
import com.example.corevo.repository.TypeRepository;
import com.example.corevo.service.TrainingExerciseSearchingService;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.experimental.FieldDefaults;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class TrainingExerciseSearchingServiceImpl implements TrainingExerciseSearchingService {
    TargetMuscleRepository targetMuscleRepository;
    GoalRepository goalRepository;
    TypeRepository typeRepository;
    LevelRepository levelRepository;

    @Override
    public TrainingExerciseSearchResultResponseDto<?> searchHandle(
            TrainingExerciseSearchingRequestDto request
    ) {
        if (request.getKeyType() == null && request.getSearchSentence() == null) {
            return searchByAll(request);
        }
        if (request.getKeyType() != null && request.getSearchSentence() == null){
            return searchByCategory(request);
        }

        String keyType = request.getKeyType();
        String searchSentence = request.getSearchSentence();

        return null;
    }

    private TrainingExerciseSearchResultResponseDto<?> searchByAll(
            TrainingExerciseSearchingRequestDto request
    ){
        TrainingExerciseSearchResultResponseDto<TargetMuscleResponseDto> result =
                new TrainingExerciseSearchResultResponseDto<TargetMuscleResponseDto>();

        return result;
    }

    private TrainingExerciseSearchResultResponseDto<?> searchByCategory(
            TrainingExerciseSearchingRequestDto request
    ){
        TrainingExerciseSearchResultResponseDto<?> result = null;
        switch (request.getKeyType()){
            case "goal" -> {
                List<GoalResponseDto> goals = null;
                result = new TrainingExerciseSearchResultResponseDto<>(goals);
            }
            case "type" -> {
                List<TypeResponseDto> types = null;
                result = new TrainingExerciseSearchResultResponseDto<>(types);
            }
            case "level" -> {
                List<LevelResponseDto> levels = null;
                result = new TrainingExerciseSearchResultResponseDto<>(levels);
            }
        };


        return result;
    }

    private TrainingExerciseSearchResultResponseDto<?> searchBySentence(
            TrainingExerciseSearchingRequestDto request
    ){

        TrainingExerciseSearchResultResponseDto<?> result = null;
        switch (request.getKeyType()){
            case "type" -> {
                List<TypeResponseDto> types = null;
                result = new TrainingExerciseSearchResultResponseDto<>(types);
            }
            case "level" -> {
                List<LevelResponseDto> levels = null;
                result = new TrainingExerciseSearchResultResponseDto<>(levels);
            }
        };


        return result;
    }

    private TrainingExerciseSearchResultResponseDto<?> searchByName(){
        return null;
    }


}
