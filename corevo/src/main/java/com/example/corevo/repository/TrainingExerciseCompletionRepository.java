package com.example.corevo.repository;

import com.example.corevo.domain.entity.training.training_schedule_details.DayOfWeek;
import com.example.corevo.domain.entity.training.training_schedule_details.TrainingExerciseCompletion;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;


import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

public interface TrainingExerciseCompletionRepository extends JpaRepository<TrainingExerciseCompletion, Long> {

    boolean existsByUser_IdAndExerciseIdAndTrainingPlanIdAndCompletionDate(
            String userId, Long exerciseId, Long trainingPlanId, LocalDate completionDate
    );

    List<TrainingExerciseCompletion> findByUser_IdAndTrainingPlanIdAndCompletionDate(
            String userId, Long trainingPlanId, LocalDate completionDate
    );
    @Query("""
        SELECT DISTINCT tegd.exercise.id FROM TrainingExerciseGroupDetail tegd
            JOIN tegd.exerciseGroup eg
            JOIN eg.trainingDay td
            JOIN td.trainingSchedule ts
        WHERE ts.trainingPlan.id = :trainingPlanId
        AND td.dayOfWeek = :dayOfWeek
        """)
    List<Long> findExerciseIdsByTrainingPlanIdAndDayOfWeek(
            @Param("trainingPlanId") Long trainingPlanId,
            @Param("dayOfWeek") DayOfWeek dayOfWeek);

    @Query("""
        SELECT COUNT(DISTINCT tegd.exercise.id) FROM TrainingExerciseGroupDetail tegd
            JOIN tegd.exerciseGroup eg
            JOIN eg.trainingDay td
            JOIN td.trainingSchedule ts
        WHERE ts.trainingPlan.id = :trainingPlanId
        AND td.dayOfWeek = :dayOfWeek
        """)
    Long countTotalExercisesByDay(@Param("trainingPlanId") Long trainingPlanId,
                                  @Param("dayOfWeek") DayOfWeek dayOfWeek);

     boolean existsByExerciseId(Long exerciseId);
}
