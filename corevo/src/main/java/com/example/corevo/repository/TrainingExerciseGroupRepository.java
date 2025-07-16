package com.example.corevo.repository;

import com.example.corevo.domain.entity.training.training_schedule_details.TrainingExerciseGroup;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TrainingExerciseGroupRepository extends JpaRepository<TrainingExerciseGroup, Long> {
}
