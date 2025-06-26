package com.example.corevo.repository;

import com.example.corevo.domain.entity.training.Goal;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface GoalRepository extends JpaRepository<Goal, Long> {
    boolean existsByGoalName(String goalName);
}
