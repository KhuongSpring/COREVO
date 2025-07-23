package com.example.corevo.domain.entity.training.training_schedule_details;

import com.example.corevo.domain.entity.training.TrainingExercise;
import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

@Entity
@Table(name = "training_group_detail")
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class TrainingExerciseGroupDetail {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    Long id;

    @ManyToOne
    @JoinColumn(name = "training_exercise_id", nullable = false)
    TrainingExercise exercise;

    String sets;

    String repsPerSet;

    String durationPerSet;

    @ManyToOne
    @JoinColumn(name = "training_exercise_group_id", nullable = false)
    TrainingExerciseGroup exerciseGroup;

}
