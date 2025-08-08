package com.example.corevo.domain.entity.training.training_personal;

import com.example.corevo.domain.entity.training.TrainingExercise;
import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDate;

@Entity
@Table(name = "personal_training_exercises")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class PersonalTrainingExercise {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "personal_training_day_id", nullable = false)
    PersonalTrainingDay personalTrainingDay;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "training_exercise_id", nullable = false)
    TrainingExercise trainingExercise;

    @Column(name = "completed_at")
    LocalDate completedAt;
}