package com.example.corevo.service.impl;

import com.example.corevo.constant.ErrorMessage;
import com.example.corevo.constant.SuccessMessage;
import com.example.corevo.domain.dto.pagination.PaginationRequestDto;
import com.example.corevo.domain.dto.pagination.PaginationResponseDto;
import com.example.corevo.domain.dto.pagination.PagingMeta;
import com.example.corevo.domain.dto.request.training.ExerciseCompletionRequestDto;
import com.example.corevo.domain.dto.request.training.PersonalTrainingPlanCreationRequestDto;
import com.example.corevo.domain.dto.request.training.TrainingExerciseSearchingRequestDto;
import com.example.corevo.domain.dto.response.CommonResponseDto;
import com.example.corevo.domain.dto.response.training.*;
import com.example.corevo.domain.dto.response.training_exercise.*;
import com.example.corevo.domain.dto.response.training_plan.PersonalTrainingDayResponseDto;
import com.example.corevo.domain.dto.response.training_plan.PersonalTrainingPlanResponseDto;
import com.example.corevo.domain.dto.response.training_plan.TrainingPlanResponseDto;
import com.example.corevo.domain.dto.response.training_schedule.*;
import com.example.corevo.domain.entity.training.*;
import com.example.corevo.domain.entity.training.training_personal.*;
import com.example.corevo.domain.entity.user.User;
import com.example.corevo.domain.mapper.*;
import com.example.corevo.exception.VsException;
import com.example.corevo.helper.StringToTrainingIDHelper;
import com.example.corevo.repository.*;
import com.example.corevo.service.TrainingProgressService;
import com.example.corevo.service.TrainingService;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.experimental.FieldDefaults;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;

import java.time.LocalDate;
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

        UserRepository userRepository;

        PersonalTrainingPlanRepository personalTrainingPlanRepository;

        PersonalTrainingDayRepository personalTrainingDayRepository;

        PersonalTrainingExerciseRepository personalTrainingExerciseRepository;

        TrainingProgressService trainingProgressService;

        TrainingExerciseMapper trainingExerciseMapper;

        TrainingPlanMapper trainingPlanMapper;

        TrainingScheduleMapper trainingScheduleMapper;

        EquipmentMapper equipmentMapper;

        GoalMapper goalMapper;

        LevelMapper levelMapper;

        LocationMapper locationMapper;

        TargetMuscleMapper targetMuscleMapper;

        TypeMapper typeMapper;

        PersonalTrainingMapper personalTrainingMapper;

        @Override
        public List<TrainingExerciseLevelPreviewResponseDto> getPreviewExerciseByPrimaryMuscle(
                        String primaryMuscle,
                        PaginationRequestDto paginationRequestDto) {
                Long beginner = 1L;
                Long intermediate = 2L;
                Long advanced = 3L;

                List<TrainingExercise> beginnerExercises = trainingExerciseRepository
                                .findByLevels_IdAndPrimaryMuscles_Id(
                                                beginner,
                                                StringToTrainingIDHelper.TargetMuscle.toId(primaryMuscle));

                List<TrainingExercise> intermediateExercises = trainingExerciseRepository
                                .findByLevels_IdAndPrimaryMuscles_Id(
                                                intermediate,
                                                StringToTrainingIDHelper.TargetMuscle.toId(primaryMuscle));

                List<TrainingExercise> advancedExercises = trainingExerciseRepository
                                .findByLevels_IdAndPrimaryMuscles_Id(
                                                advanced,
                                                StringToTrainingIDHelper.TargetMuscle.toId(primaryMuscle));

                List<TrainingExercisePreviewResponseDto> allExercises = new ArrayList<>();

                allExercises.addAll(trainingExerciseMapper
                                .listTrainingExerciseToListTrainingExercisePreviewResponseDto(beginnerExercises)
                                .stream()
                                .peek(dto -> dto.setLevelName("Beginner"))
                                .toList());

                allExercises.addAll(trainingExerciseMapper
                                .listTrainingExerciseToListTrainingExercisePreviewResponseDto(intermediateExercises)
                                .stream()
                                .peek(dto -> dto.setLevelName("Intermediate"))
                                .toList());

                allExercises.addAll(trainingExerciseMapper
                                .listTrainingExerciseToListTrainingExercisePreviewResponseDto(advancedExercises)
                                .stream()
                                .peek(dto -> dto.setLevelName("Advanced"))
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

                for (String level : List.of("Beginner", "Intermediate", "Advanced")) {
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
                Long beginner = 1L;
                Long intermediate = 2L;
                Long advanced = 3L;

                List<TrainingExercise> beginnerExercises = trainingExerciseRepository
                                .findByLevels_IdAndTypes_Id(
                                                beginner,
                                                StringToTrainingIDHelper.Type.toId(type));

                List<TrainingExercise> intermediateExercises = trainingExerciseRepository
                                .findByLevels_IdAndTypes_Id(
                                                intermediate,
                                                StringToTrainingIDHelper.Type.toId(type));

                List<TrainingExercise> advancedExercises = trainingExerciseRepository
                                .findByLevels_IdAndTypes_Id(
                                                advanced,
                                                StringToTrainingIDHelper.Type.toId(type));

                List<TrainingExercisePreviewResponseDto> allExercises = new ArrayList<>();

                allExercises.addAll(trainingExerciseMapper
                                .listTrainingExerciseToListTrainingExercisePreviewResponseDto(beginnerExercises)
                                .stream()
                                .peek(dto -> dto.setLevelName("Beginner"))
                                .toList());

                allExercises.addAll(trainingExerciseMapper
                                .listTrainingExerciseToListTrainingExercisePreviewResponseDto(intermediateExercises)
                                .stream()
                                .peek(dto -> dto.setLevelName("Intermediate"))
                                .toList());

                allExercises.addAll(trainingExerciseMapper
                                .listTrainingExerciseToListTrainingExercisePreviewResponseDto(advancedExercises)
                                .stream()
                                .peek(dto -> dto.setLevelName("Advanced"))
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

                for (String level : List.of("Beginner", "Intermediate", "Advanced")) {
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
                Long beginner = 1L;
                Long intermediate = 2L;
                Long advanced = 3L;

                List<TrainingExercise> beginnerExercises = trainingExerciseRepository
                                .findByLevels_IdAndGoals_Id(
                                                beginner,
                                                StringToTrainingIDHelper.Goal.toId(goal));

                List<TrainingExercise> intermediateExercises = trainingExerciseRepository
                                .findByLevels_IdAndGoals_Id(
                                                intermediate,
                                                StringToTrainingIDHelper.Goal.toId(goal));

                List<TrainingExercise> advancedExercises = trainingExerciseRepository
                                .findByLevels_IdAndGoals_Id(
                                                advanced,
                                                StringToTrainingIDHelper.Goal.toId(goal));

                List<TrainingExercisePreviewResponseDto> allExercises = new ArrayList<>();

                allExercises.addAll(trainingExerciseMapper
                                .listTrainingExerciseToListTrainingExercisePreviewResponseDto(beginnerExercises)
                                .stream()
                                .peek(dto -> dto.setLevelName("Beginner"))
                                .toList());

                allExercises.addAll(trainingExerciseMapper
                                .listTrainingExerciseToListTrainingExercisePreviewResponseDto(intermediateExercises)
                                .stream()
                                .peek(dto -> dto.setLevelName("Intermediate"))
                                .toList());

                allExercises.addAll(trainingExerciseMapper
                                .listTrainingExerciseToListTrainingExercisePreviewResponseDto(advancedExercises)
                                .stream()
                                .peek(dto -> dto.setLevelName("Advanced"))
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

                for (String level : List.of("Beginner", "Intermediate", "Advanced")) {
                        if (groupedByLevel.containsKey(level)) {
                                response.add(new TrainingExerciseLevelPreviewResponseDto(level,
                                                groupedByLevel.get(level)));
                        }
                }

                return response;
        }

        @Override
        public PaginationResponseDto<TrainingExercisePreviewResponseDto> searchExercise(
                        TrainingExerciseSearchingRequestDto request,
                        PaginationRequestDto paginationRequestDto) {

                List<TrainingExercisePreviewResponseDto> result;

                Pageable pageable = PageRequest.of(
                                paginationRequestDto.getPageNum(),
                                paginationRequestDto.getPageSize());

                Page<TrainingExercise> trainingExercisesPage = trainingExerciseRepository
                                .findByNameContainingIgnoreCase(
                                                request.getSearchSentence(),
                                                pageable);

                result = trainingExercisesPage.getContent()
                                .stream()
                                .map(trainingExerciseMapper::trainingExerciseToTrainingExercisePreviewResponseDto)
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

        @Override
        public TrainingExerciseResponseDto getTrainingExerciseById(Long id) {
                TrainingExercise trainingExercise = trainingExerciseRepository.findById(id)
                                .orElseThrow(() -> new VsException(
                                                HttpStatus.BAD_REQUEST,
                                                ErrorMessage.Training.ERR_EXERCISE_NOT_EXISTS));

                return trainingExerciseMapper.trainingExerciseToTrainingExerciseResponseDto(trainingExercise);
        }

        @Override
        public PaginationResponseDto<TrainingPlanResponseDto> getTrainingPlans(
                        PaginationRequestDto paginationRequestDto) {
                Pageable pageable = PageRequest.of(
                                paginationRequestDto.getPageNum(),
                                paginationRequestDto.getPageSize());

                Page<TrainingPlan> trainingPage = trainingPlanRepository.findAll(pageable);

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
                Pageable pageable = PageRequest.of(
                                request.getPageNum(),
                                request.getPageSize());

                Page<Equipment> equipmentPage = equipmentRepository.findAll(pageable);

                List<EquipmentResponseDto> equipmentResponseDtos = equipmentPage.getContent()
                                .stream()
                                .map(equipmentMapper::equipmentToEquipmentResponseDto)
                                .toList();

                PagingMeta pagingMeta = new PagingMeta(
                                equipmentPage.getTotalElements(),
                                equipmentPage.getTotalPages(),
                                request.getPageNum() + 1,
                                request.getPageSize(),
                                null,
                                null);

                return new PaginationResponseDto<>(pagingMeta, equipmentResponseDtos);
        }

        @Override
        public PaginationResponseDto<GoalResponseDto> getGoals(PaginationRequestDto request) {
                Pageable pageable = PageRequest.of(
                                request.getPageNum(),
                                request.getPageSize());

                Page<Goal> goalPage = goalRepository.findAll(pageable);

                List<GoalResponseDto> goalResponseDtos = goalPage.getContent()
                                .stream()
                                .map(goalMapper::goalToGoalResponseDto)
                                .toList();

                PagingMeta pagingMeta = new PagingMeta(
                                goalPage.getTotalElements(),
                                goalPage.getTotalPages(),
                                request.getPageNum() + 1,
                                request.getPageSize(),
                                null,
                                null);

                return new PaginationResponseDto<>(pagingMeta, goalResponseDtos);
        }

        @Override
        public PaginationResponseDto<LevelResponseDto> getLevels(PaginationRequestDto request) {
                Pageable pageable = PageRequest.of(
                                request.getPageNum(),
                                request.getPageSize());

                Page<Level> levelPage = levelRepository.findAll(pageable);

                List<LevelResponseDto> levelResponseDtos = levelPage.getContent()
                                .stream()
                                .map(levelMapper::levelToLevelResponseDto)
                                .toList();

                PagingMeta pagingMeta = new PagingMeta(
                                levelPage.getTotalElements(),
                                levelPage.getTotalPages(),
                                request.getPageNum() + 1,
                                request.getPageSize(),
                                null, null);

                return new PaginationResponseDto<>(pagingMeta, levelResponseDtos);
        }

        @Override
        public PaginationResponseDto<LocationResponseDto> getLocations(PaginationRequestDto request) {

                Pageable pageable = PageRequest.of(
                                request.getPageNum(),
                                request.getPageSize());

                Page<Location> locationPage = locationRepository.findAll(pageable);

                List<LocationResponseDto> locationResponseDtos = locationPage.getContent()
                                .stream().map(locationMapper::locationToLocationResponseDto)
                                .toList();

                PagingMeta pagingMeta = new PagingMeta(
                                locationPage.getTotalElements(),
                                locationPage.getTotalPages(),
                                request.getPageNum() + 1,
                                request.getPageSize(),
                                null, null);

                return new PaginationResponseDto<>(pagingMeta, locationResponseDtos);

        }

        @Override
        public PaginationResponseDto<TargetMuscleResponseDto> getTargetMuscles(PaginationRequestDto request) {
                Pageable pageable = PageRequest.of(
                                request.getPageNum(),
                                request.getPageSize());

                Page<TargetMuscle> targetMusclePage = targetMuscleRepository.findAll(pageable);

                List<TargetMuscleResponseDto> targetMuscleResponseDtos = targetMusclePage.getContent()
                                .stream()
                                .map(targetMuscleMapper::targetMuscleToTargetMuscleResponseDto)
                                .toList();

                PagingMeta pagingMeta = new PagingMeta(
                                targetMusclePage.getTotalElements(),
                                targetMusclePage.getTotalPages(),
                                request.getPageNum() + 1,
                                request.getPageSize(),
                                null,
                                null);

                return new PaginationResponseDto<>(pagingMeta, targetMuscleResponseDtos);
        }

        @Override
        public PaginationResponseDto<TypeResponseDto> getTypes(PaginationRequestDto request) {
                Pageable pageable = PageRequest.of(
                                request.getPageNum(),
                                request.getPageSize());

                Page<Type> typePage = typeRepository.findAll(pageable);

                List<TypeResponseDto> typeResponseDtos = typePage.getContent()
                                .stream()
                                .map(typeMapper::typeToTypeResponseDto)
                                .toList();

                PagingMeta pagingMeta = new PagingMeta(
                                typePage.getTotalElements(),
                                typePage.getTotalPages(),
                                request.getPageNum() + 1,
                                request.getPageSize(),
                                null,
                                null);

                return new PaginationResponseDto<>(pagingMeta, typeResponseDtos);
        }

        @Override
        public TrainingScheduleResponseDto getTrainingSchedule(Long planId) {
                return trainingScheduleMapper
                                .trainingScheduleToTrainingScheduleResponseDto(
                                                trainingScheduleRepository.findByTrainingPlan_Id(planId));
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
        public PersonalTrainingPlanResponseDto createPersonalTrainingPlan(
                        PersonalTrainingPlanCreationRequestDto request,
                        Authentication authentication) {

                String username = authentication.getName();

                if (!userRepository.existsUserByUsername(username))
                        throw new VsException(HttpStatus.NOT_FOUND, ErrorMessage.User.ERR_USER_NOT_EXISTED);

                User user = userRepository.findByUsername(username);

                if (personalTrainingPlanRepository.existsByUserAndPlanName(user, request.getPlanName())) {
                        throw new VsException(HttpStatus.BAD_REQUEST,
                                        ErrorMessage.Training.ERR_TRAINING_PLAN_NAME_EXISTED);
                }

                Goal goal = goalRepository.findById(request.getGoalId())
                                .orElseThrow(() -> new VsException(HttpStatus.NOT_FOUND,
                                                ErrorMessage.Training.ERR_GOAL_NOT_FOUND));

                Type type = typeRepository.findById(request.getTypeId())
                                .orElseThrow(() -> new VsException(HttpStatus.NOT_FOUND,
                                                ErrorMessage.Training.ERR_TYPE_NOT_FOUND));

                PersonalTrainingPlan plan = PersonalTrainingPlan.builder()
                                .planName(request.getPlanName())
                                .description(request.getDescription())
                                .goal(goal)
                                .type(type)
                                .user(user)
                                .build();

                PersonalTrainingPlan savedPlan = personalTrainingPlanRepository.save(plan);

                return PersonalTrainingPlanResponseDto.builder()
                                .planId(savedPlan.getId())
                                .planName(savedPlan.getPlanName())
                                .description(savedPlan.getDescription())
                                .goalName(savedPlan.getGoal().getGoalName())
                                .typeName(savedPlan.getType().getTypeName())
                                .userId(user.getId())
                                .build();
        }

        @Override
        public List<TrainingExerciseResponseDto> getAvailableExercisesForPlan(Long planId,
                        Authentication authentication) {
                PersonalTrainingPlan plan = validatePersonalTrainingPlanOwner(planId, authentication);

                return trainingExerciseRepository.findByGoalIdAndTypeId(
                                plan.getGoal().getId(),
                                plan.getType().getId())
                                .stream()
                                .map(trainingExerciseMapper::trainingExerciseToTrainingExerciseResponseDto)
                                .toList();
        }

        @Override
        public List<PersonalTrainingDayResponseDto> getPersonalTrainingDays(Long planId,
                        Authentication authentication) {

                PersonalTrainingPlan plan = validatePersonalTrainingPlanOwner(planId, authentication);

                List<PersonalTrainingDay> days = personalTrainingDayRepository
                                .findByPersonalTrainingPlanOrderByActualDateDesc(plan);

                return days.stream()
                                .map(day -> {
                                        List<TrainingExerciseResponseDto> exercises = personalTrainingExerciseRepository
                                                        .findByPersonalTrainingDayOrderByCompletedAtDesc(day)
                                                        .stream()
                                                        .map(pe -> trainingExerciseMapper
                                                                        .trainingExerciseToTrainingExerciseResponseDto(
                                                                                        pe.getTrainingExercise()))
                                                        .toList();

                                        PersonalTrainingDayResponseDto dto = personalTrainingMapper
                                                        .personalTrainingDayToPersonalTrainingDayResponseDto(day);
                                        dto.setCompletedExercises(exercises);

                                        return dto;
                                })
                                .toList();
        }

        @Override
        public CommonResponseDto completeExerciseForPersonalPlan(
                        Long planId,
                        ExerciseCompletionRequestDto request,
                        Authentication authentication) {

                PersonalTrainingPlan plan = validatePersonalTrainingPlanOwner(planId, authentication);

                trackExerciseInPersonalPlan(plan, request);

                return new CommonResponseDto(
                                HttpStatus.OK,
                                SuccessMessage.Exercise.COMPLETE_EXERCISE_SUCCESS);
        }

        private void trackExerciseInPersonalPlan(PersonalTrainingPlan plan, ExerciseCompletionRequestDto request) {
                LocalDate today = LocalDate.now();

                PersonalTrainingDay trainingDay = personalTrainingDayRepository
                                .findByPersonalTrainingPlanAndActualDate(plan, today)
                                .orElseGet(() -> {
                                        int dayNumber = personalTrainingDayRepository.countByPersonalTrainingPlan(plan)
                                                        + 1;

                                        PersonalTrainingDay newDay = PersonalTrainingDay.builder()
                                                        .personalTrainingPlan(plan)
                                                        .dayNumber(dayNumber)
                                                        .actualDate(today)
                                                        .isRestDay(false)
                                                        .build();

                                        return personalTrainingDayRepository.save(newDay);
                                });

                TrainingExercise exercise = trainingExerciseRepository.findById(request.getExerciseId())
                                .orElseThrow(() -> new VsException(HttpStatus.NOT_FOUND,
                                                ErrorMessage.Training.ERR_EXERCISE_NOT_EXISTS));

                boolean alreadyCompleted = personalTrainingExerciseRepository
                                .findByPersonalTrainingDay(trainingDay)
                                .stream()
                                .anyMatch(pe
                                        -> pe.getTrainingExercise().getId().equals(request.getExerciseId()));

                if (alreadyCompleted) {
                        throw new VsException(HttpStatus.BAD_REQUEST,
                                        ErrorMessage.Training.ERR_EXERCISE_HAS_BEEN_COMPLETED);
                }

                PersonalTrainingExercise personalExercise = PersonalTrainingExercise.builder()
                                .personalTrainingDay(trainingDay)
                                .trainingExercise(exercise)
                                .completedAt(LocalDate.now())
                                .build();

                personalTrainingExerciseRepository.save(personalExercise);

                trainingDay.setIsRestDay(false);

                personalTrainingDayRepository.save(trainingDay);
        }

        @Override
        public List<PersonalTrainingPlanResponseDto> getUserPersonalTrainingPlans(Authentication authentication) {
                String username = authentication.getName();

                if (!userRepository.existsUserByUsername(username))
                        throw new VsException(HttpStatus.NOT_FOUND, ErrorMessage.User.ERR_USER_NOT_EXISTED);

                User user = userRepository.findByUsername(username);

                List<PersonalTrainingPlan> plans = personalTrainingPlanRepository.findByUserOrderByIdDesc(user);

                return plans
                                .stream()
                                .map(plan -> PersonalTrainingPlanResponseDto
                                                .builder()
                                                .planId(plan.getId())
                                                .planName(plan.getPlanName())
                                                .description(plan.getDescription())
                                                .goalName(plan.getGoal().getGoalName())
                                                .typeName(plan.getType().getTypeName())
                                                .userId(user.getId())
                                                .build())
                                .toList();
        }

        @Override
        public CommonResponseDto deletePersonalTrainingPlan(Long planId, Authentication authentication) {
                PersonalTrainingPlan plan = validatePersonalTrainingPlanOwner(planId, authentication);

                String username = authentication.getName();
                User user = userRepository.findByUsername(username);

                if (!plan.getUser().getId().equals(user.getId())) {
                        throw new VsException(HttpStatus.FORBIDDEN, ErrorMessage.FORBIDDEN_UPDATE_DELETE);
                }

                personalTrainingPlanRepository.delete(plan);

                return new CommonResponseDto(HttpStatus.OK, SuccessMessage.TrainingPlan.DELETE_TRAINING_PLAN_SUCCESS);
        }

        private PersonalTrainingPlan validatePersonalTrainingPlanOwner(Long planId, Authentication authentication) {
                String username = authentication.getName();

                if (!userRepository.existsUserByUsername(username))
                        throw new VsException(HttpStatus.NOT_FOUND, ErrorMessage.User.ERR_USER_NOT_EXISTED);

                PersonalTrainingPlan plan = personalTrainingPlanRepository.findById(planId)
                                .orElseThrow(() -> new VsException(HttpStatus.NOT_FOUND,
                                                ErrorMessage.Training.ERR_TRAINING_PLAN_NOT_EXISTS));

                return plan;
        }

}
