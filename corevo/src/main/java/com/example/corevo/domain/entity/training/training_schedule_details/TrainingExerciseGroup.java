package com.example.corevo.domain.entity.training.training_schedule_details;

import com.example.corevo.domain.entity.training.TrainingExercise;
import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.util.List;

@Entity
@Table(name = "training_group")
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class TrainingExerciseGroup {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    Long id;

    String name;

    @ManyToOne
    @JoinColumn(name = "training_day_id", nullable = false)
    TrainingDay trainingDay;

    @ManyToMany
    @JoinTable(
            name = "training_group_exercise",
            joinColumns = @JoinColumn(name = "training_exercise_group_id"),
            inverseJoinColumns = @JoinColumn(name = "training_exercise_id")
    )
    List<TrainingExercise> trainingExercises;
}
