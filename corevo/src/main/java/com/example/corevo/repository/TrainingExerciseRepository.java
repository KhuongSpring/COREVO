package com.example.corevo.repository;

import com.example.corevo.domain.entity.TrainingExercise;
import com.example.corevo.domain.entity.training.TargetMuscle;
import com.example.corevo.domain.entity.training.Type;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TrainingExerciseRepository extends JpaRepository<TrainingExercise, Long> {
    boolean existsByNameAndTypesAndPrimaryMuscles(String name, List<Type> types, List<TargetMuscle> primaryMuscles);
}
