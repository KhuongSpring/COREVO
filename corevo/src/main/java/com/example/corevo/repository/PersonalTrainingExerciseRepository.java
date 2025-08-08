package com.example.corevo.repository;

import com.example.corevo.domain.entity.training.training_personal.PersonalTrainingDay;
import com.example.corevo.domain.entity.training.training_personal.PersonalTrainingExercise;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface PersonalTrainingExerciseRepository extends JpaRepository<PersonalTrainingExercise, Long> {

    List<PersonalTrainingExercise> findByPersonalTrainingDay(PersonalTrainingDay personalTrainingDay);

    List<PersonalTrainingExercise> findByPersonalTrainingDayOrderByCompletedAtDesc(
            PersonalTrainingDay personalTrainingDay);

}