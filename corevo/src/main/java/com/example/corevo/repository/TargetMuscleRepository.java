package com.example.corevo.repository;

import com.example.corevo.domain.entity.training.TargetMuscle;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TargetMuscleRepository extends JpaRepository<TargetMuscle, Long> {

    boolean existsByTargetMuscleName(String targetMuscleName);

}
