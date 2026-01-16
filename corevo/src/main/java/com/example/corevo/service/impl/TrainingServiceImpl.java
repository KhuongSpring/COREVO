package com.example.corevo.service.impl;

import com.example.corevo.constant.ErrorMessage;
import com.example.corevo.domain.dto.pagination.PaginationRequestDto;
import com.example.corevo.domain.dto.pagination.PaginationResponseDto;
import com.example.corevo.domain.dto.pagination.PagingMeta;
import com.example.corevo.domain.dto.request.training.TrainingDynamicSearchingRequestDto;
import com.example.corevo.domain.dto.response.training.*;
import com.example.corevo.domain.dto.response.training_exercise.*;
import com.example.corevo.domain.dto.response.training_plan.TrainingPlanResponseDto;
import com.example.corevo.domain.dto.response.training_schedule.TrainingScheduleResponseDto;
import com.example.corevo.domain.entity.training.*;
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
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;

import java.util.*;
import java.util.stream.Collectors;

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

        private static final Long BEGINNER_LEVEL_ID = 1L;
        private static final Long INTERMEDIATE_LEVEL_ID = 2L;
        private static final Long ADVANCED_LEVEL_ID = 3L;
        private static final String BEGINNER_LEVEL_NAME = "Beginner";
        private static final String INTERMEDIATE_LEVEL_NAME = "Intermediate";
        private static final String ADVANCED_LEVEL_NAME = "Advanced";

        @Override
        public PaginationResponseDto<TrainingPlanResponseDto> getTrainingPlans(
                        PaginationRequestDto request) {
                Pageable pageable = PageRequest.of(request.getPageNum(), request.getPageSize());
                Page<TrainingPlan> page = trainingPlanRepository.findAll(pageable);
                return getPaginatedEntities(page, trainingPlanMapper::trainingPlanToTrainingPlanResponseDto, request);
        }

        @Override
        public PaginationResponseDto<TrainingPlanResponseDto> getTrainingPlanByType(String type,
                        PaginationRequestDto paginationRequestDto) {
                Pageable pageable = PageRequest.of(
                                paginationRequestDto.getPageNum(),
                                paginationRequestDto.getPageSize());

                Page<TrainingPlan> trainingPage = trainingPlanRepository.findByType(type, pageable);

                List<TrainingPlanResponseDto> trainingPlanResponseDtos = trainingPage.getContent()
                                .stream()
                                .map(trainingPlanMapper::trainingPlanToTrainingPlanResponseDto)
                                .toList();

                PagingMeta pagingMeta = new PagingMeta(
                                trainingPage.getTotalElements(),
                                trainingPage.getTotalPages(),
                                paginationRequestDto.getPageNum() + 1,
                                paginationRequestDto.getPageSize(),
                                null,
                                null);

                return new PaginationResponseDto<>(pagingMeta, trainingPlanResponseDtos);
        }

        @Override
        public PaginationResponseDto<EquipmentResponseDto> getEquipments(PaginationRequestDto request) {
                Pageable pageable = PageRequest.of(request.getPageNum(), request.getPageSize());
                Page<Equipment> page = equipmentRepository.findAll(pageable);
                return getPaginatedEntities(page, equipmentMapper::equipmentToEquipmentResponseDto, request);
        }

        @Override
        public PaginationResponseDto<GoalResponseDto> getGoals(PaginationRequestDto request) {
                Pageable pageable = PageRequest.of(request.getPageNum(), request.getPageSize());
                Page<Goal> page = goalRepository.findAll(pageable);
                return getPaginatedEntities(page, goalMapper::goalToGoalResponseDto, request);
        }

        @Override
        public PaginationResponseDto<LevelResponseDto> getLevels(PaginationRequestDto request) {
                Pageable pageable = PageRequest.of(request.getPageNum(), request.getPageSize());
                Page<Level> page = levelRepository.findAll(pageable);
                return getPaginatedEntities(page, levelMapper::levelToLevelResponseDto, request);
        }

        @Override
        public PaginationResponseDto<LocationResponseDto> getLocations(PaginationRequestDto request) {
                Pageable pageable = PageRequest.of(request.getPageNum(), request.getPageSize());
                Page<Location> page = locationRepository.findAll(pageable);
                return getPaginatedEntities(page, locationMapper::locationToLocationResponseDto, request);
        }

        @Override
        public PaginationResponseDto<TargetMuscleResponseDto> getTargetMuscles(PaginationRequestDto request) {
                Pageable pageable = PageRequest.of(request.getPageNum(), request.getPageSize());
                Page<TargetMuscle> page = targetMuscleRepository.findAll(pageable);
                return getPaginatedEntities(page, targetMuscleMapper::targetMuscleToTargetMuscleResponseDto, request);
        }

        @Override
        public PaginationResponseDto<TypeResponseDto> getTypes(PaginationRequestDto request) {
                Pageable pageable = PageRequest.of(request.getPageNum(), request.getPageSize());
                Page<Type> page = typeRepository.findAll(pageable);
                return getPaginatedEntities(page, typeMapper::typeToTypeResponseDto, request);
        }

        @Override
        public TypeResponseDto getTypeById(Long id) {
                return getEntityByIdOrThrow(typeRepository, typeMapper::typeToTypeResponseDto, id,
                                ErrorMessage.Training.ERR_TYPE_NOT_EXISTS);
        }

        @Override
        public TargetMuscleResponseDto getTargetMuscleById(Long id) {
                return getEntityByIdOrThrow(targetMuscleRepository,
                                targetMuscleMapper::targetMuscleToTargetMuscleResponseDto, id,
                                ErrorMessage.Training.ERR_TARGET_MUSCLE_NOT_EXISTS);
        }

        @Override
        public TrainingPlanResponseDto getTrainingPlanById(Long id) {
                return getEntityByIdOrThrow(trainingPlanRepository,
                                trainingPlanMapper::trainingPlanToTrainingPlanResponseDto, id,
                                ErrorMessage.Training.ERR_TRAINING_PLAN_NOT_EXISTS);
        }

        @Override
        public LocationResponseDto getLocationById(Long id) {
                return getEntityByIdOrThrow(locationRepository, locationMapper::locationToLocationResponseDto, id,
                                ErrorMessage.Training.ERR_LOCATION_NOT_EXISTS);
        }

        @Override
        public LevelResponseDto getLevelById(Long id) {
                return getEntityByIdOrThrow(levelRepository, levelMapper::levelToLevelResponseDto, id,
                                ErrorMessage.Training.ERR_LEVEL_NOT_EXISTS);
        }

        @Override
        public GoalResponseDto getGoalById(Long id) {
                return getEntityByIdOrThrow(goalRepository, goalMapper::goalToGoalResponseDto, id,
                                ErrorMessage.Training.ERR_GOAL_NOT_EXISTS);
        }

        @Override
        public EquipmentResponseDto getEquipmentById(Long id) {
                return getEntityByIdOrThrow(equipmentRepository, equipmentMapper::equipmentToEquipmentResponseDto, id,
                                ErrorMessage.Training.ERR_EQUIPMENT_NOT_EXISTS);
        }

        @Override
        public List<TrainingExerciseLevelPreviewResponseDto> getPreviewExerciseByPrimaryMuscle(
                        String primaryMuscle,
                        PaginationRequestDto paginationRequestDto) {
                List<TrainingExercise> beginnerExercises = trainingExerciseRepository
                                .findByLevels_IdAndPrimaryMuscles_Id(
                                                BEGINNER_LEVEL_ID,
                                                StringToTrainingIDHelper.TargetMuscle.toId(primaryMuscle));

                List<TrainingExercise> intermediateExercises = trainingExerciseRepository
                                .findByLevels_IdAndPrimaryMuscles_Id(
                                                INTERMEDIATE_LEVEL_ID,
                                                StringToTrainingIDHelper.TargetMuscle.toId(primaryMuscle));

                List<TrainingExercise> advancedExercises = trainingExerciseRepository
                                .findByLevels_IdAndPrimaryMuscles_Id(
                                                ADVANCED_LEVEL_ID,
                                                StringToTrainingIDHelper.TargetMuscle.toId(primaryMuscle));

                List<TrainingExercisePreviewResponseDto> allExercises = new ArrayList<>();

                allExercises.addAll(trainingExerciseMapper
                                .listTrainingExerciseToListTrainingExercisePreviewResponseDto(beginnerExercises)
                                .stream()
                                .peek(dto -> dto.setLevelName(BEGINNER_LEVEL_NAME))
                                .toList());

                allExercises.addAll(trainingExerciseMapper
                                .listTrainingExerciseToListTrainingExercisePreviewResponseDto(intermediateExercises)
                                .stream()
                                .peek(dto -> dto.setLevelName(INTERMEDIATE_LEVEL_NAME))
                                .toList());

                allExercises.addAll(trainingExerciseMapper
                                .listTrainingExerciseToListTrainingExercisePreviewResponseDto(advancedExercises)
                                .stream()
                                .peek(dto -> dto.setLevelName(ADVANCED_LEVEL_NAME))
                                .toList());

                int pageNum = paginationRequestDto.getPageNum() + 1;
                int pageSize = paginationRequestDto.getPageSize();

                int start = (pageNum - 1) * pageSize;
                int end = Math.min(start + pageSize, allExercises.size());

                if (start >= allExercises.size()) {
                        return List.of();
                }

                List<TrainingExercisePreviewResponseDto> pagedExercises = allExercises.subList(start, end);

                Map<String, List<TrainingExercisePreviewResponseDto>> groupedByLevel = pagedExercises
                                .stream()
                                .collect(Collectors.groupingBy(TrainingExercisePreviewResponseDto::getLevelName));

                List<TrainingExerciseLevelPreviewResponseDto> response = new ArrayList<>();

                for (String level : List.of(BEGINNER_LEVEL_NAME, INTERMEDIATE_LEVEL_NAME, ADVANCED_LEVEL_NAME)) {
                        if (groupedByLevel.containsKey(level)) {
                                response.add(new TrainingExerciseLevelPreviewResponseDto(level,
                                                groupedByLevel.get(level)));
                        }
                }

                return response;
        }

        @Override
        public List<TrainingExerciseLevelPreviewResponseDto> getPreviewExerciseByType(
                        String type,
                        PaginationRequestDto paginationRequestDto) {
                List<TrainingExercise> beginnerExercises = trainingExerciseRepository
                                .findByLevels_IdAndTypes_Id(
                                                BEGINNER_LEVEL_ID,
                                                StringToTrainingIDHelper.Type.toId(type));

                List<TrainingExercise> intermediateExercises = trainingExerciseRepository
                                .findByLevels_IdAndTypes_Id(
                                                INTERMEDIATE_LEVEL_ID,
                                                StringToTrainingIDHelper.Type.toId(type));

                List<TrainingExercise> advancedExercises = trainingExerciseRepository
                                .findByLevels_IdAndTypes_Id(
                                                ADVANCED_LEVEL_ID,
                                                StringToTrainingIDHelper.Type.toId(type));

                List<TrainingExercisePreviewResponseDto> allExercises = new ArrayList<>();

                allExercises.addAll(trainingExerciseMapper
                                .listTrainingExerciseToListTrainingExercisePreviewResponseDto(beginnerExercises)
                                .stream()
                                .peek(dto -> dto.setLevelName(BEGINNER_LEVEL_NAME))
                                .toList());

                allExercises.addAll(trainingExerciseMapper
                                .listTrainingExerciseToListTrainingExercisePreviewResponseDto(intermediateExercises)
                                .stream()
                                .peek(dto -> dto.setLevelName(INTERMEDIATE_LEVEL_NAME))
                                .toList());

                allExercises.addAll(trainingExerciseMapper
                                .listTrainingExerciseToListTrainingExercisePreviewResponseDto(advancedExercises)
                                .stream()
                                .peek(dto -> dto.setLevelName(ADVANCED_LEVEL_NAME))
                                .toList());

                int pageNum = paginationRequestDto.getPageNum() + 1;
                int pageSize = paginationRequestDto.getPageSize();

                int start = (pageNum - 1) * pageSize;
                int end = Math.min(start + pageSize, allExercises.size());

                if (start >= allExercises.size()) {
                        return List.of();
                }

                List<TrainingExercisePreviewResponseDto> pagedExercises = allExercises.subList(start, end);

                Map<String, List<TrainingExercisePreviewResponseDto>> groupedByLevel = pagedExercises
                                .stream()
                                .collect(Collectors.groupingBy(TrainingExercisePreviewResponseDto::getLevelName));

                List<TrainingExerciseLevelPreviewResponseDto> response = new ArrayList<>();

                for (String level : List.of(BEGINNER_LEVEL_NAME, INTERMEDIATE_LEVEL_NAME, ADVANCED_LEVEL_NAME)) {
                        if (groupedByLevel.containsKey(level)) {
                                response.add(new TrainingExerciseLevelPreviewResponseDto(level,
                                                groupedByLevel.get(level)));
                        }
                }

                return response;
        }

        @Override
        public List<TrainingExerciseLevelPreviewResponseDto> getPreviewExerciseByGoal(
                        String goal,
                        PaginationRequestDto paginationRequestDto) {
                List<TrainingExercise> beginnerExercises = trainingExerciseRepository
                                .findByLevels_IdAndGoals_Id(
                                                BEGINNER_LEVEL_ID,
                                                StringToTrainingIDHelper.Goal.toId(goal));

                List<TrainingExercise> intermediateExercises = trainingExerciseRepository
                                .findByLevels_IdAndGoals_Id(
                                                INTERMEDIATE_LEVEL_ID,
                                                StringToTrainingIDHelper.Goal.toId(goal));

                List<TrainingExercise> advancedExercises = trainingExerciseRepository
                                .findByLevels_IdAndGoals_Id(
                                                ADVANCED_LEVEL_ID,
                                                StringToTrainingIDHelper.Goal.toId(goal));

                List<TrainingExercisePreviewResponseDto> allExercises = new ArrayList<>();

                allExercises.addAll(trainingExerciseMapper
                                .listTrainingExerciseToListTrainingExercisePreviewResponseDto(beginnerExercises)
                                .stream()
                                .peek(dto -> dto.setLevelName(BEGINNER_LEVEL_NAME))
                                .toList());

                allExercises.addAll(trainingExerciseMapper
                                .listTrainingExerciseToListTrainingExercisePreviewResponseDto(intermediateExercises)
                                .stream()
                                .peek(dto -> dto.setLevelName(INTERMEDIATE_LEVEL_NAME))
                                .toList());

                allExercises.addAll(trainingExerciseMapper
                                .listTrainingExerciseToListTrainingExercisePreviewResponseDto(advancedExercises)
                                .stream()
                                .peek(dto -> dto.setLevelName(ADVANCED_LEVEL_NAME))
                                .toList());

                int pageNum = paginationRequestDto.getPageNum() + 1;
                int pageSize = paginationRequestDto.getPageSize();

                int start = (pageNum - 1) * pageSize;
                int end = Math.min(start + pageSize, allExercises.size());

                if (start >= allExercises.size()) {
                        return List.of();
                }

                List<TrainingExercisePreviewResponseDto> pagedExercises = allExercises.subList(start, end);

                Map<String, List<TrainingExercisePreviewResponseDto>> groupedByLevel = pagedExercises
                                .stream()
                                .collect(Collectors.groupingBy(TrainingExercisePreviewResponseDto::getLevelName));

                List<TrainingExerciseLevelPreviewResponseDto> response = new ArrayList<>();

                for (String level : List.of(BEGINNER_LEVEL_NAME, INTERMEDIATE_LEVEL_NAME, ADVANCED_LEVEL_NAME)) {
                        if (groupedByLevel.containsKey(level)) {
                                response.add(new TrainingExerciseLevelPreviewResponseDto(level,
                                                groupedByLevel.get(level)));
                        }
                }

                return response;
        }

        @Override
        public TrainingExerciseResponseDto getTrainingExerciseById(Long id) {
                TrainingExercise trainingExercise = trainingExerciseRepository.findById(id)
                                .orElseThrow(() -> new VsException(
                                                HttpStatus.BAD_REQUEST,
                                                ErrorMessage.Training.ERR_EXERCISE_NOT_EXISTS));

                return trainingExerciseMapper.trainingExerciseToTrainingExerciseResponseDto(trainingExercise);
        }

        @Override
        public List<Long> searchTrainingPlanDynamic(TrainingDynamicSearchingRequestDto request) {
                boolean hasLevelFilter = !request.getLevels().isEmpty();
                boolean hasLocationFilter = !request.getLocations().isEmpty();
                boolean hasEquipmentFilter = !request.getEquipments().isEmpty();
                boolean hasGoalFilter = request.getGoal() != null && !request.getGoal().isEmpty();

                return trainingExerciseRepository.searchDynamicTrainingPlan(
                                request.getSearchSentence(),
                                request.getLevels(),
                                request.getLocations(),
                                request.getEquipments(),
                                request.getGoal(),
                                hasLevelFilter,
                                hasLocationFilter,
                                hasEquipmentFilter,
                                hasGoalFilter);
        }

        @Override
        public List<TrainingExercisePreviewResponseDto> searchTrainingExerciseDynamic(
                        TrainingDynamicSearchingRequestDto request) {
                boolean hasLevelFilter = !request.getLevels().isEmpty();
                boolean hasLocationFilter = !request.getLocations().isEmpty();
                boolean hasEquipmentFilter = !request.getEquipments().isEmpty();
                boolean hasGoalFilter = request.getGoal() != null && !request.getGoal().isEmpty();

                // Because goal is not a list in request, but in query it is a list
                List<Long> listGoal = new ArrayList<>();

                Goal goal = goalRepository.findByName(request.getGoal())
                                .orElse(null);

                if (goal != null) {
                        listGoal.add(goal.getId());
                }

                List<Long> exerciseResponseSearch = trainingExerciseRepository.searchDynamicTrainingExercise(
                                request.getSearchSentence(),
                                request.getLevels(),
                                request.getLocations(),
                                request.getEquipments(),
                                listGoal,
                                hasLevelFilter,
                                hasLocationFilter,
                                hasEquipmentFilter,
                                hasGoalFilter);

                List<TrainingExercise> exercises = trainingExerciseRepository.findAllById(exerciseResponseSearch);

                return exercises.stream()
                                .map(trainingExerciseMapper::trainingExerciseToTrainingExercisePreviewResponseDto)
                                .collect(Collectors.toList());
        }

        @Override
        public TrainingScheduleResponseDto getTrainingSchedule(Long planId) {
                return trainingScheduleMapper
                                .trainingScheduleToTrainingScheduleResponseDto(
                                                trainingScheduleRepository.findByTrainingPlan_Id(planId));
        }

        @Override
        public PaginationResponseDto<TrainingExerciseResponseDto> getAllExercise(
                        PaginationRequestDto paginationRequestDto) {

                Pageable pageable = PageRequest.of(paginationRequestDto.getPageNum(),
                                paginationRequestDto.getPageSize());

                Page<TrainingExercise> exercisesPage = trainingExerciseRepository.findAll(pageable);

                List<TrainingExerciseResponseDto> exercises = exercisesPage.getContent()
                                .stream()
                                .map(trainingExerciseMapper::trainingExerciseToTrainingExerciseResponseDto)
                                .collect(Collectors.toList());

                PagingMeta pagingMeta = new PagingMeta(
                                exercisesPage.getTotalElements(),
                                exercisesPage.getTotalPages(),
                                paginationRequestDto.getPageNum() + 1,
                                paginationRequestDto.getPageSize(),
                                null,
                                null);

                return new PaginationResponseDto<>(pagingMeta, exercises);
        }

        @Override
        public PaginationResponseDto<TrainingExerciseResponseDto> searchTrainingExercise(
                        String searchRequest,
                        PaginationRequestDto paginationRequestDto) {

                List<TrainingExerciseResponseDto> result;

                Pageable pageable = PageRequest.of(
                                paginationRequestDto.getPageNum(),
                                paginationRequestDto.getPageSize());

                Page<TrainingExercise> trainingExercisesPage = trainingExerciseRepository
                                .findByNameContainingIgnoreCase(
                                                searchRequest,
                                                pageable);

                result = trainingExercisesPage.getContent()
                                .stream()
                                .map(trainingExerciseMapper::trainingExerciseToTrainingExerciseResponseDto)
                                .filter(Objects::nonNull)
                                .toList();

                PagingMeta pagingMeta = new PagingMeta(
                                trainingExercisesPage.getTotalElements(),
                                trainingExercisesPage.getTotalPages(),
                                paginationRequestDto.getPageNum() + 1,
                                paginationRequestDto.getPageSize(),
                                null,
                                null);

                return new PaginationResponseDto<>(pagingMeta, result);
        }

        private <T, D> PaginationResponseDto<D> getPaginatedEntities(
                        Page<T> entityPage,
                        java.util.function.Function<T, D> mapper,
                        PaginationRequestDto request) {

                List<D> dtos = entityPage.getContent()
                                .stream()
                                .map(mapper)
                                .toList();

                PagingMeta pagingMeta = new PagingMeta(
                                entityPage.getTotalElements(),
                                entityPage.getTotalPages(),
                                request.getPageNum() + 1,
                                request.getPageSize(),
                                null,
                                null);

                return new PaginationResponseDto<>(pagingMeta, dtos);
        }

        private <T, D> D getEntityByIdOrThrow(
                        org.springframework.data.jpa.repository.JpaRepository<T, Long> repository,
                        java.util.function.Function<T, D> mapper,
                        Long id,
                        String errorMessage) {

                T entity = repository.findById(id)
                                .orElseThrow(() -> new VsException(HttpStatus.BAD_REQUEST, errorMessage));

                return mapper.apply(entity);
        }

}
