package com.example.corevo.service.impl;

import com.example.corevo.constant.ErrorMessage;
import com.example.corevo.domain.dto.request.training.ExerciseCompletionRequestDto;
import com.example.corevo.domain.dto.response.training_progress.DailyProgressResponseDto;
import com.example.corevo.domain.dto.response.training_progress.CompletionStatisticResponseDto;
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

import java.time.DateTimeException;
import java.time.LocalDate;
import java.util.*;
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

        if(user.getTrainingPlans() == null || user.getTrainingPlans().isEmpty())
            throw new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.Training.ERR_USER_NOT_IN_TRAINING_PLAN);

        Long trainingPlanId = user.getTrainingPlans().getFirst().getId();

        if(user.getTrainingPlans() == null || user.getTrainingPlans().isEmpty())
            throw new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.Training.ERR_USER_NOT_IN_TRAINING_PLAN);

        int completedDays = 0;

        for (int i = 0; i < 7; i++){
            LocalDate checkDate = weekStart.plusDays(i);
            DayOfWeek checkDayOfWeek = DayOfWeek.valueOf(checkDate.getDayOfWeek().toString());
            Long totalExercisesForDay = completionRepository.countTotalExercisesByDay(trainingPlanId, checkDayOfWeek);

            if(totalExercisesForDay == 0){
                if (checkDate.isBefore(today) || checkDate.isEqual(today)) {
                    completedDays++;
                }
                continue;
            }

            if (checkDate.isBefore(today) || checkDate.isEqual(today)) {
                List<TrainingExerciseCompletion> dayCompletions = completionRepository
                        .findByUser_IdAndTrainingPlanIdAndCompletionDate(user.getId(), trainingPlanId, checkDate);

                if (dayCompletions.size() == totalExercisesForDay.intValue()) {
                    completedDays++;
                }
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

    @Override
    public CompletionStatisticResponseDto getCompletionStatistic(Integer year, Integer month, Authentication authentication) {

        String username = authentication.getName();

        if(!userRepository.existsUserByUsername(username))
            throw new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.User.ERR_USER_NOT_EXISTED);

        User user = userRepository.findByUsername(username);


        if(user.getTrainingPlans() == null || user.getTrainingPlans().isEmpty())
            throw new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.Training.ERR_USER_NOT_IN_TRAINING_PLAN);

        LocalDate today = LocalDate.now();
        int targetYear = (year == null) ? today.getYear() : year;
        int targetMonth = (month == null) ? today.getMonthValue() : month;

        LocalDate startOfMonth;
        try {
            startOfMonth = LocalDate.of(targetYear, targetMonth, 1);
        } catch (DateTimeException e) {
            throw new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.INVALID_DATE +" "+ e.getMessage());
        }
        int dayInMonth = startOfMonth.lengthOfMonth();
        LocalDate endOfMonth = startOfMonth.withDayOfMonth(dayInMonth);

        LocalDate accountCreationDate = user.getCreatedAt();
        if (startOfMonth.isBefore(accountCreationDate.withDayOfMonth(1))
                || startOfMonth.isAfter(today.withDayOfMonth(1))) {
            throw new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.INVALID_DATE);
        }


        List<LocalDate> completedDateInMonth = completionRepository
                .findCompletionDatesByUserAndDateRange(user.getId(), startOfMonth, endOfMonth);

        List<Boolean> currentMonthCompletions = new ArrayList<>();
        for(int i = 1; i <= dayInMonth; i++){
            LocalDate currDate = LocalDate.of(targetYear, targetMonth, i);
            currentMonthCompletions.add(completedDateInMonth.contains(currDate));
        }


        List<LocalDate> allCompletionDates = completionRepository.findAllCompletionDatesByUserId(user.getId());

        Integer currentStreak = calculateCurrentStreak(allCompletionDates, today);

        Integer longestStreak = calculateLongestStreak(allCompletionDates);


        return new CompletionStatisticResponseDto(
                changeMonthToString(targetMonth),
                targetYear,
                currentMonthCompletions,
                currentStreak,
                longestStreak
                );
    }

    private String changeMonthToString(Integer month){
        String[] monthName = {
            "January", "February", "March", "April", "May", "June",
            "July", "August", "September", "October", "November", "December"
        };

        return monthName[month - 1];
    }

    private Integer calculateCurrentStreak(List<LocalDate> allCompletionDates, LocalDate today) {
        if (allCompletionDates.isEmpty()) return 0;

        Set<LocalDate> completionSet = new HashSet<>(allCompletionDates);

        int streak = 0;
        LocalDate checkDate = today;

        if (!completionSet.contains(today)) {
            checkDate = today.minusDays(1);
        }

        while (completionSet.contains(checkDate)) {
            streak++;
            checkDate = checkDate.minusDays(1);
        }

        return streak;
    }


    private Integer calculateLongestStreak(List<LocalDate> allCompletionDates){
        if (allCompletionDates.isEmpty()) return 0;

        int maxStreak = 0;
        int currentStreak = 1;

        for(int i = 1; i < allCompletionDates.size(); i++){
            LocalDate currDate = allCompletionDates.get(i);
            LocalDate prevDate = allCompletionDates.get(i - 1);

            if(prevDate.plusDays(1).equals(currDate)){
                currentStreak++;
            } else{
                maxStreak = Math.max(maxStreak, currentStreak);
                currentStreak = 1;
            }
        }
        return Math.max(maxStreak, currentStreak);
    }

}


