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

        boolean existsTrainingExercisesByName(String name);

        @Query("""
                        SELECT DISTINCT te FROM TrainingExercise te
                        WHERE (:name IS NULL OR LOWER(te.name) LIKE LOWER(CONCAT('%', :name, '%')))
                        """)
        Page<TrainingExercise> findByNameContainingIgnoreCase(String name, Pageable pageable);

        @Query(value = """
                        SELECT DISTINCT tp.id
                        FROM training_plan tp
                        LEFT JOIN training_plan_levels     tpl  ON tp.id = tpl.training_plan_id
                        LEFT JOIN training_plan_locations  tplc ON tp.id = tplc.training_plan_id
                        LEFT JOIN training_plan_equipments tpe  ON tp.id = tpe.training_plan_id
                        WHERE
                            (:searchSentence IS NULL OR :searchSentence = ''
                              OR tp.name  LIKE LOWER(CONCAT('%', :searchSentence, '%'))
                              OR tp.type  LIKE LOWER(CONCAT('%', :searchSentence, '%'))
                              OR tp.goals LIKE LOWER(CONCAT('%', :searchSentence, '%'))
                            )
                            AND (:hasGoalFilter      = FALSE OR tp.goals         LIKE LOWER(CONCAT('%', :goal, '%')))
                            AND (:hasLevelFilter     = FALSE OR tpl.level_id     IN (:levels))
                            AND (:hasLocationFilter  = FALSE OR tplc.location_id IN (:locations))
                            AND (:hasEquipmentFilter = FALSE OR tpe.equipment_id IN (:equipments))
                        """, nativeQuery = true)
        List<Long> searchDynamicTrainingPlan(
                        @Param("searchSentence") String searchSentence,
                        @Param("levels") List<Long> levels,
                        @Param("locations") List<Long> locations,
                        @Param("equipments") List<Long> equipments,
                        @Param("goal") String goal,
                        @Param("hasLevelFilter") boolean hasLevelFilter,
                        @Param("hasLocationFilter") boolean hasLocationFilter,
                        @Param("hasEquipmentFilter") boolean hasEquipmentFilter,
                        @Param("hasGoalFilter") boolean hasGoalFilter);

        @Query(value = """
                        SELECT DISTINCT te.id
                        FROM training_exercise te
                        LEFT JOIN training_exercise_levels     tel  ON te.id = tel.training_exercise_id
                        LEFT JOIN training_exercise_locations  telc ON te.id = telc.training_exercise_id
                        LEFT JOIN training_exercise_equipments tee  ON te.id = tee.training_exercise_id
                        LEFT JOIN training_exercise_goals      teg  ON te.id = teg.training_exercise_id
                        WHERE
                            (:searchSentence IS NULL OR :searchSentence = ''
                              OR te.name  LIKE LOWER(CONCAT('%', :searchSentence, '%'))
                            )
                            AND (:hasGoalFilter      = FALSE OR teg.goal_id      IN (:goals))
                            AND (:hasLevelFilter     = FALSE OR tel.level_id     IN (:levels))
                            AND (:hasLocationFilter  = FALSE OR telc.location_id IN (:locations))
                            AND (:hasEquipmentFilter = FALSE OR tee.equipment_id IN (:equipments))
                        """, nativeQuery = true)
        List<Long> searchDynamicTrainingExercise(
                        @Param("searchSentence") String searchSentence,
                        @Param("levels") List<Long> levels,
                        @Param("locations") List<Long> locations,
                        @Param("equipments") List<Long> equipments,
                        @Param("goals") List<Long> goals,
                        @Param("hasLevelFilter") boolean hasLevelFilter,
                        @Param("hasLocationFilter") boolean hasLocationFilter,
                        @Param("hasEquipmentFilter") boolean hasEquipmentFilter,
                        @Param("hasGoalFilter") boolean hasGoalFilter);
}
