package com.example.corevo.repository;

import com.example.corevo.domain.entity.training.training_schedule_details.TrainingSchedule;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TrainingScheduleRepository extends JpaRepository<TrainingSchedule, Long> {
}
