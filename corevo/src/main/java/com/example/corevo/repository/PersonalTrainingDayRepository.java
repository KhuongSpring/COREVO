package com.example.corevo.repository;

import com.example.corevo.domain.entity.training.training_personal.PersonalTrainingDay;
import com.example.corevo.domain.entity.training.training_personal.PersonalTrainingPlan;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface PersonalTrainingDayRepository extends JpaRepository<PersonalTrainingDay, Long> {

    Optional<PersonalTrainingDay> findByPersonalTrainingPlanAndActualDate(
            PersonalTrainingPlan personalTrainingPlan, LocalDate actualDate);

    List<PersonalTrainingDay> findByPersonalTrainingPlanOrderByActualDateDesc(
            PersonalTrainingPlan personalTrainingPlan);

    int countByPersonalTrainingPlan(PersonalTrainingPlan personalTrainingPlan);

}