package com.example.corevo.repository;

import com.example.corevo.domain.entity.training.TrainingExercise;
import org.springframework.data.jpa.repository.JpaRepository;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.List;
import java.util.Optional;

@Repository
public interface TrainingExerciseRepository extends JpaRepository<TrainingExercise, Long> {

    boolean existsByNameAndTypes_IdInAndPrimaryMuscles_IdIn(String name, List<Long> typeIds, List<Long> muscleIds);

    List<TrainingExercise> findByLevels_IdAndPrimaryMuscles_Id(Long levelsId, Optional<Long> primaryMusclesId);

    List<TrainingExercise> findByLevels_IdAndTypes_Id(Long levelsId, Optional<Long> typesId);

    List<TrainingExercise> findByLevels_IdAndGoals_Id(Long levelsId, Optional<Long> goalsId);

    @Query("""
           SELECT DISTINCT te FROM TrainingExercise te
           WHERE (:name IS NULL OR LOWER(te.name) LIKE LOWER(CONCAT('%', :name, '%')))
           """
    )
    Page<TrainingExercise> findByNameContainingIgnoreCase(String name, Pageable pageable);

    @Query(value = """
            SELECT DISTINCT te.* FROM training_exercise te
            JOIN training_exercise_goals teg ON te.id = teg.training_exercise_id
            JOIN training_exercise_types tet ON te.id = tet.training_exercise_id
            WHERE teg.goal_id = :goalId AND tet.type_id = :typeId
            """, nativeQuery = true)
    List<TrainingExercise> findByGoalIdAndTypeId(
            @Param("goalId") Long goalId,
            @Param("typeId") Long typeId);
}
