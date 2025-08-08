package com.example.corevo.repository;

import com.example.corevo.domain.entity.training.training_personal.PersonalTrainingPlan;
import com.example.corevo.domain.entity.user.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PersonalTrainingPlanRepository extends JpaRepository<PersonalTrainingPlan, Long> {

    boolean existsByUserAndPlanName(User user, String planName);

    List<PersonalTrainingPlan> findByUserOrderByIdDesc(User user);
}