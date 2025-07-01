package com.example.corevo.repository;

import com.example.corevo.domain.entity.TrainingExercise;
import com.example.corevo.domain.entity.training.TargetMuscle;
import com.example.corevo.domain.entity.training.Type;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Collection;
import java.util.List;

@Repository
public interface TrainingExerciseRepository extends JpaRepository<TrainingExercise, Long> {

    boolean existsByNameAndTypes_IdInAndPrimaryMuscles_IdIn(String name, List<Long> typeIds, List<Long> muscleIds);
}
