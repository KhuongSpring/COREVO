package com.example.corevo.domain.entity.training.training_schedule_details;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;
import com.example.corevo.domain.entity.user.User;

import java.time.LocalDate;

@Entity
@Table(name = "training_exercise_completion")
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class TrainingExerciseCompletion {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    Long id;

    @ManyToOne
    @JoinColumn(name = "user_id")
    User user;

    @Column(name = "training_plan_id")
    Long trainingPlanId;

    @Column(name = "exercise_id")
    Long exerciseId;

    @Column(name = "is_completed")
    Boolean isCompleted;

    @Column(name = "completion_date")
    LocalDate completionDate;

}
