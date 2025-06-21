package com.example.corevo.repository;

import com.example.corevo.domain.entity.training.TrainingPlan;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TrainingPlanRepository extends JpaRepository<TrainingPlan, Long> {
    @Query(value = """
    SELECT DISTINCT tp.* FROM training_plan tp
    LEFT JOIN training_plan_levels tpl ON tp.id = tpl.training_plan_id
    LEFT JOIN training_plan_locations tplc ON tp.id = tplc.training_plan_id
    LEFT JOIN training_plan_equipments tpe ON tp.id = tpe.training_plan_id
    WHERE (:goals IS NULL OR tp.goals = :goals)
      AND (:type IS NULL OR tp.type = :type)
      AND (:duration IS NULL OR tp.duration = :duration)
      AND (:frequency IS NULL OR tp.frequency = :frequency)
      AND (:levelIds IS NULL OR tpl.level_id IN (:levelIds))
      AND (:locationIds IS NULL OR tplc.location_id IN (:locationIds))
      AND (:equipmentIds IS NULL OR tpe.equipment_id IN (:equipmentIds))
""", nativeQuery = true)
    List<TrainingPlan> searchPlans(
            @Param("goals") String goals,
            @Param("type") String type,
            @Param("duration") String duration,
            @Param("frequency") String frequency,
            @Param("levelIds") List<Long> levelIds,
            @Param("locationIds") List<Long> locationIds,
            @Param("equipmentIds") List<Long> equipmentIds
    );
}
