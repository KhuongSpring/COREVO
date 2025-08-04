package com.example.corevo.service.impl;

import com.example.corevo.constant.ErrorMessage;
import com.example.corevo.domain.dto.request.training.ExerciseCompletionRequestDto;
import com.example.corevo.domain.dto.response.training_progress.DailyProgressResponseDto;
import com.example.corevo.domain.dto.response.training_progress.WeeklyProgressResponseDto;
import com.example.corevo.domain.entity.training.TrainingPlan;
import com.example.corevo.domain.entity.training.training_schedule_details.DayOfWeek;
import com.example.corevo.domain.entity.training.training_schedule_details.TrainingExerciseCompletion;
import com.example.corevo.domain.entity.user.User;
import com.example.corevo.exception.VsException;
import com.example.corevo.repository.TrainingExerciseCompletionRepository;
import com.example.corevo.repository.UserRepository;
import com.example.corevo.service.TrainingProgressService;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.experimental.FieldDefaults;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.time.temporal.TemporalAdjusters;

@Service
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class TrainingProgressServiceImpl implements TrainingProgressService {

    TrainingExerciseCompletionRepository completionRepository;
    UserRepository userRepository;

    @Override
    public void completeExercise(ExerciseCompletionRequestDto request, Authentication authentication) {

        String username = authentication.getName();

        if(!userRepository.existsUserByUsername(username))
            throw new VsException(HttpStatus.NOT_FOUND, ErrorMessage.User.ERR_USER_NOT_EXISTED);

        User user = userRepository.findByUsername(username);
        LocalDate today = LocalDate.now();
        DayOfWeek dayOfWeek = DayOfWeek.valueOf(today.getDayOfWeek().toString());

        if(user.getTrainingPlans() == null || user.getTrainingPlans().isEmpty())
            throw new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.Training.ERR_USER_NOT_IN_TRAINING_PLAN);

        TrainingPlan trainingPlan = user.getTrainingPlans().getFirst();

        List<Long> todayExerciseIds = completionRepository
                .findExerciseIdsByTrainingPlanIdAndDayOfWeek(trainingPlan.getId(), dayOfWeek);

        if(!todayExerciseIds.contains(request.getExerciseId()))
            throw new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.Training.ERR_EXERCISE_NOT_EXISTS_DAY);

        if(completionRepository.existsByExerciseId(request.getExerciseId()))
            throw new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.Training.ERR_EXERCISE_HAS_BEEN_COMPLETED);

        boolean alreadyCompleted = completionRepository
                .existsByUser_IdAndExerciseIdAndTrainingPlanIdAndCompletionDate(
                        user.getId(), request.getExerciseId(), trainingPlan.getId(), today
                );

        if(!alreadyCompleted){
            TrainingExerciseCompletion completion = TrainingExerciseCompletion.builder()
                    .user(user)
                    .exerciseId(request.getExerciseId())
                    .trainingPlanId(trainingPlan.getId())
                    .completionDate(today)
                    .isCompleted(true)
                    .build();

            completionRepository.save(completion);
        }
    }

    @Override
    public DailyProgressResponseDto getDailyProgress(Authentication authentication) {

        LocalDate today = LocalDate.now();
        DayOfWeek dayOfWeek = DayOfWeek.valueOf(today.getDayOfWeek().toString());

        String username = authentication.getName();

        if(!userRepository.existsUserByUsername(username))
            throw new VsException(HttpStatus.NOT_FOUND, ErrorMessage.User.ERR_USER_NOT_EXISTED);

        User user = userRepository.findByUsername(username);

        if(user.getTrainingPlans() == null || user.getTrainingPlans().isEmpty())
            throw new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.Training.ERR_USER_NOT_IN_TRAINING_PLAN);

        TrainingPlan trainingPlan = user.getTrainingPlans().getFirst();

        List<TrainingExerciseCompletion> completedToday = completionRepository
                .findByUser_IdAndTrainingPlanIdAndCompletionDate(user.getId(), trainingPlan.getId(), today);

        List<Long> completedExerciseIds = completedToday.stream()
                .map(TrainingExerciseCompletion::getExerciseId)
                .toList();

        List<Long> todayExerciseIds = completionRepository
                .findExerciseIdsByTrainingPlanIdAndDayOfWeek(trainingPlan.getId(), dayOfWeek);

        if(todayExerciseIds.isEmpty())
            return new DailyProgressResponseDto(
                    trainingPlan.getId(),
                    dayOfWeek.toString(),
                    new HashMap<>(),
                    100.00);

        Map<String, Boolean> completions = new HashMap<>();
        for (Long exerciseIds : todayExerciseIds){
            completions.put(exerciseIds.toString(), completedExerciseIds.contains(exerciseIds));
        }

        int totalExercises = todayExerciseIds.size();
        int completedCount = completedExerciseIds.size();
        double percentage = (double) (completedCount * 100) / totalExercises;
        percentage = Math.round(percentage * 100.0) / 100.0;

        return new DailyProgressResponseDto(
                trainingPlan.getId(),
                dayOfWeek.toString(),
                completions,
                percentage
        );
    }

    @Override
    public WeeklyProgressResponseDto getWeeklyProgress(Authentication authentication) {

        LocalDate today = LocalDate.now();
        LocalDate weekStart = today.with(TemporalAdjusters.previousOrSame(java.time.DayOfWeek.MONDAY));

        String username = authentication.getName();

        if(!userRepository.existsUserByUsername(username))
            throw new VsException(HttpStatus.NOT_FOUND, ErrorMessage.User.ERR_USER_NOT_EXISTED);

        User user = userRepository.findByUsername(username);
        Long trainingPlanId = user.getTrainingPlans().getFirst().getId();

        if(user.getTrainingPlans() == null || user.getTrainingPlans().isEmpty())
            throw new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.Training.ERR_USER_NOT_IN_TRAINING_PLAN);

        int completedDays = 0;

        for (int i = 0; i < 7; i++){
            LocalDate checkDate = weekStart.plusDays(i);
            DayOfWeek checkDayOfWeek = DayOfWeek.valueOf(checkDate.getDayOfWeek().toString());
            Long totalExercisesForDay = completionRepository.countTotalExercisesByDay(trainingPlanId, checkDayOfWeek);

            if(totalExercisesForDay == 0){
                completedDays++;
                continue;
            }

            List<TrainingExerciseCompletion> dayCompletions = completionRepository
                    .findByUser_IdAndTrainingPlanIdAndCompletionDate(user.getId(), trainingPlanId, checkDate);

            if (dayCompletions.size() == totalExercisesForDay.intValue()) {
                completedDays++;
            }
        }
        double weeklyPercentage = (completedDays * 100.0) / 7;
        weeklyPercentage = Math.round(weeklyPercentage * 100.0) / 100.0;
        return new WeeklyProgressResponseDto(
                trainingPlanId,
                weeklyPercentage,
                completedDays
        );
    }
}
