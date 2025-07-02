package com.example.corevo.repository;

import com.example.corevo.domain.entity.training.TrainingExercise;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface TrainingExerciseRepository extends JpaRepository<TrainingExercise, Long> {

    boolean existsByNameAndTypes_IdInAndPrimaryMuscles_IdIn(String name, List<Long> typeIds, List<Long> muscleIds);

    List<TrainingExercise> findByLevels_IdAndPrimaryMuscles_Id(Long levelsId, Optional<Long> primaryMusclesId);

    List<TrainingExercise> findByLevels_IdAndTypes_Id(Long levelsId, Optional<Long> typesId);

    List<TrainingExercise> findByLevels_IdAndGoals_Id(Long levelsId, Optional<Long> goalsId);
}
