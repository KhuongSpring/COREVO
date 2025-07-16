package com.example.corevo.service.impl;

import com.example.corevo.constant.ErrorMessage;
import com.example.corevo.domain.dto.request.training.TrainingExerciseSearchingRequestDto;
import com.example.corevo.domain.dto.response.training.*;
import com.example.corevo.domain.dto.response.training_exercise.*;
import com.example.corevo.domain.dto.response.training_plan.TrainingPlanResponseDto;
import com.example.corevo.domain.dto.response.training_schedule.TrainingScheduleResponseDto;
import com.example.corevo.domain.entity.training.TrainingExercise;
import com.example.corevo.domain.mapper.*;
import com.example.corevo.exception.VsException;
import com.example.corevo.helper.StringToTrainingIDHelper;
import com.example.corevo.repository.*;
import com.example.corevo.service.TrainingService;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.experimental.FieldDefaults;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class TrainingServiceImpl implements TrainingService {

    TrainingExerciseRepository trainingExerciseRepository;

    TrainingPlanRepository trainingPlanRepository;

    TrainingScheduleRepository trainingScheduleRepository;

    EquipmentRepository equipmentRepository;

    GoalRepository goalRepository;

    LevelRepository levelRepository;

    LocationRepository locationRepository;

    TargetMuscleRepository targetMuscleRepository;

    TypeRepository typeRepository;


    TrainingExerciseMapper trainingExerciseMapper;

    TrainingPlanMapper trainingPlanMapper;

    TrainingScheduleMapper trainingScheduleMapper;

    EquipmentMapper equipmentMapper;

    GoalMapper goalMapper;

    LevelMapper levelMapper;

    LocationMapper locationMapper;

    TargetMuscleMapper targetMuscleMapper;

    TypeMapper typeMapper;

    @Override
    public List<TrainingExerciseLevelPreviewResponseDto> getPreviewExerciseByPrimaryMuscle(
            String primaryMuscle
    ) {
        Long beginner = 1L;
        Long intermediate = 2L;
        Long advanced = 3L;

        List<TrainingExerciseLevelPreviewResponseDto> result = new ArrayList<>();

        result.add(new TrainingExerciseLevelPreviewResponseDto(
                "Beginner",
                trainingExerciseMapper.
                        listTrainingExerciseToListTrainingExercisePreviewResponseDto(
                                trainingExerciseRepository.
                                        findByLevels_IdAndPrimaryMuscles_Id(
                                                beginner,
                                                StringToTrainingIDHelper.TargetMuscle.toId(primaryMuscle)
                                        )
                        )
        ));

        result.add(new TrainingExerciseLevelPreviewResponseDto(
                "Intermediate",
                trainingExerciseMapper.listTrainingExerciseToListTrainingExercisePreviewResponseDto(
                        trainingExerciseRepository.
                                findByLevels_IdAndPrimaryMuscles_Id(
                                        intermediate,
                                        StringToTrainingIDHelper.TargetMuscle.toId(primaryMuscle)
                                )
                )
        ));

        result.add(new TrainingExerciseLevelPreviewResponseDto(
                "Advanced",
                trainingExerciseMapper.listTrainingExerciseToListTrainingExercisePreviewResponseDto(
                        trainingExerciseRepository.
                                findByLevels_IdAndPrimaryMuscles_Id(
                                        advanced,
                                        StringToTrainingIDHelper.TargetMuscle.toId(primaryMuscle)
                                )
                )
        ));

        return result;
    }

    @Override
    public List<TrainingExerciseLevelPreviewResponseDto> getPreviewExerciseByType(
            String type
    ) {
        Long beginner = 1L;
        Long intermediate = 2L;
        Long advanced = 3L;

        List<TrainingExerciseLevelPreviewResponseDto> result = new ArrayList<>();

        result.add(new TrainingExerciseLevelPreviewResponseDto(
                "Beginner",
                trainingExerciseMapper.
                        listTrainingExerciseToListTrainingExercisePreviewResponseDto(
                                trainingExerciseRepository.
                                        findByLevels_IdAndTypes_Id(
                                                beginner,
                                                StringToTrainingIDHelper.Type.toId(type)
                                        )
                        )
        ));

        result.add(new TrainingExerciseLevelPreviewResponseDto(
                "Intermediate",
                trainingExerciseMapper.listTrainingExerciseToListTrainingExercisePreviewResponseDto(
                        trainingExerciseRepository.
                                findByLevels_IdAndTypes_Id(
                                        intermediate,
                                        StringToTrainingIDHelper.Type.toId(type)
                                )
                )
        ));

        result.add(new TrainingExerciseLevelPreviewResponseDto(
                "Advanced",
                trainingExerciseMapper.listTrainingExerciseToListTrainingExercisePreviewResponseDto(
                        trainingExerciseRepository.
                                findByLevels_IdAndTypes_Id(
                                        advanced,
                                        StringToTrainingIDHelper.Type.toId(type)
                                )
                )
        ));

        return result;
    }

    @Override
    public List<TrainingExerciseLevelPreviewResponseDto> getPreviewExerciseByGoal(
            String goal
    ) {
        Long beginner = 1L;
        Long intermediate = 2L;
        Long advanced = 3L;

        List<TrainingExerciseLevelPreviewResponseDto> result = new ArrayList<>();

        result.add(new TrainingExerciseLevelPreviewResponseDto(
                "Beginner",
                trainingExerciseMapper.
                        listTrainingExerciseToListTrainingExercisePreviewResponseDto(
                                trainingExerciseRepository.
                                        findByLevels_IdAndGoals_Id(
                                                beginner,
                                                StringToTrainingIDHelper.Goal.toId(goal)
                                        )
                        )
        ));

        result.add(new TrainingExerciseLevelPreviewResponseDto(
                "Intermediate",
                trainingExerciseMapper.listTrainingExerciseToListTrainingExercisePreviewResponseDto(
                        trainingExerciseRepository.
                                findByLevels_IdAndGoals_Id(
                                        intermediate,
                                        StringToTrainingIDHelper.Goal.toId(goal)
                                )
                )
        ));

        result.add(new TrainingExerciseLevelPreviewResponseDto(
                "Advanced",
                trainingExerciseMapper.listTrainingExerciseToListTrainingExercisePreviewResponseDto(
                        trainingExerciseRepository.
                                findByLevels_IdAndGoals_Id(
                                        advanced,
                                        StringToTrainingIDHelper.Goal.toId(goal)
                                )
                )
        ));

        return result;
    }

    @Override
    public List<TrainingExercisePreviewResponseDto> searchExercise(TrainingExerciseSearchingRequestDto request) {

        List<TrainingExercisePreviewResponseDto> result = new ArrayList<>();

        switch (request.getKeyType()) {

            case "targetMuscle" -> {
                List<TrainingExerciseLevelPreviewResponseDto> levelPreview =
                        getPreviewExerciseByPrimaryMuscle(request.getSearchSentence());

                result.addAll(levelPreview.get(0).getExercises());
                result.addAll(levelPreview.get(1).getExercises());
                result.addAll(levelPreview.get(2).getExercises());
            }

            case "type" -> {
                List<TrainingExerciseLevelPreviewResponseDto> levelPreview =
                        getPreviewExerciseByType(request.getSearchSentence());

                result.addAll(levelPreview.get(0).getExercises());
                result.addAll(levelPreview.get(1).getExercises());
                result.addAll(levelPreview.get(2).getExercises());
            }

            case "goal" -> {
                List<TrainingExerciseLevelPreviewResponseDto> levelPreview =
                        getPreviewExerciseByGoal(request.getSearchSentence());

                result.addAll(levelPreview.get(0).getExercises());
                result.addAll(levelPreview.get(1).getExercises());
                result.addAll(levelPreview.get(2).getExercises());
            }

            default -> {
                List<TrainingExercisePreviewResponseDto> resultSearch = trainingExerciseMapper
                        .listTrainingExerciseToListTrainingExercisePreviewResponseDto(
                                trainingExerciseRepository.findByNameContainingIgnoreCase(request.getSearchSentence())
                        );

                result.addAll(resultSearch);
            }
        }

        return result;
    }

    @Override
    public TrainingExerciseResponseDto getTrainingExerciseById(Long id) {
        TrainingExercise trainingExercise = trainingExerciseRepository.findById(id)
                .orElseThrow(() -> new VsException(
                        HttpStatus.BAD_REQUEST,
                        ErrorMessage.Training.ERR_EXERCISE_NOT_EXISTS)
                );

        return trainingExerciseMapper.trainingExerciseToTrainingExerciseResponseDto(trainingExercise);
    }

    @Override
    public List<TrainingPlanResponseDto> getTrainingPlans() {
        return trainingPlanMapper.listTrainingPlanToListTrainingPlanResponseDto(
                trainingPlanRepository.findAll()
        );
    }

    @Override
    public List<EquipmentResponseDto> getEquipments() {
        return equipmentMapper.listEquipmentToListEquipmentResponseDto(
                equipmentRepository.findAll()
        );
    }

    @Override
    public List<GoalResponseDto> getGoals() {
        return goalMapper.listGoalToListGoalResponseDto(
                goalRepository.findAll()
        );
    }

    @Override
    public List<LevelResponseDto> getLevels() {
        return levelMapper.listLevelToListLevelResponseDto(
                levelRepository.findAll()
        );
    }

    @Override
    public List<LocationResponseDto> getLocations() {
        return locationMapper.listLocationToListLocationResponseDto(
                locationRepository.findAll()
        );
    }

    @Override
    public List<TargetMuscleResponseDto> getTargetMuscles() {
        return targetMuscleMapper.listTargetMuscleToListTargetMuscleResponseDto(
                targetMuscleRepository.findAll()
        );
    }

    @Override
    public List<TypeResponseDto> getTypes() {
        return typeMapper.listTypeToListTypeResponseDto(
                typeRepository.findAll()
        );
    }

    @Override
    public TrainingScheduleResponseDto getTrainingSchedule(Long planId) {
        return trainingScheduleMapper
                .trainingScheduleToTrainingScheduleResponseDto(
                        trainingScheduleRepository.findByTrainingPlan_Id(planId)
                );
    }

}
