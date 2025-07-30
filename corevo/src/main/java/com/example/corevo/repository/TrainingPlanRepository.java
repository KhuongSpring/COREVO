package com.example.corevo.repository;

import com.example.corevo.domain.entity.training.TrainingExercise;
import com.example.corevo.domain.entity.training.TrainingPlan;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TrainingPlanRepository extends JpaRepository<TrainingPlan, Long> {

    @Query(value = """
    SELECT DISTINCT tp.* FROM training_plan tp
    LEFT JOIN training_plan_levels     tpl  ON tp.id = tpl.training_plan_id
    LEFT JOIN training_plan_locations  tplc ON tp.id = tplc.training_plan_id
    LEFT JOIN training_plan_equipments tpe  ON tp.id = tpe.training_plan_id
    WHERE (:hasGoalsFilter     = FALSE OR tp.goals     IN (:goals))
      AND (:hasTypeFilter      = FALSE OR tp.type      IN (:types))
      AND (:hasDurationFilter  = FALSE OR tp.duration  IN (:durations))
      AND (:hasFrequencyFilter = FALSE OR tp.frequency IN (:frequencies))
      AND (:hasLevelFilter     = FALSE OR tpl.level_id     IN (:levelIds))
      AND (:hasLocationFilter  = FALSE OR tplc.location_id IN (:locationIds))
      AND (:hasEquipmentFilter = FALSE OR tpe.equipment_id IN (:equipmentIds))
""", nativeQuery = true)
    List<TrainingPlan> searchPlans(
            @Param("hasGoalsFilter")     boolean hasGoalsFilter,
            @Param("hasTypeFilter")      boolean hasTypeFilter,
            @Param("hasDurationFilter")  boolean hasDurationFilter,
            @Param("hasFrequencyFilter") boolean hasFrequencyFilter,
            @Param("hasLevelFilter")     boolean hasLevelFilter,
            @Param("hasLocationFilter")  boolean hasLocationFilter,
            @Param("hasEquipmentFilter") boolean hasEquipmentFilter,

            @Param("goals")        List<String> goals,
            @Param("types")        List<String> types,
            @Param("durations")    List<String> durations,
            @Param("frequencies")  List<String> frequencies,

            @Param("levelIds")     List<Long> levelIds,
            @Param("locationIds")  List<Long> locationIds,
            @Param("equipmentIds") List<Long> equipmentIds
    );


    boolean existsByNameAndType(String name, String type);
    Page<TrainingPlan> findByType(String type, Pageable pageable);
}
