package com.example.corevo.domain.entity.training.training_schedule_details;

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

    String note;

    @OneToOne
    @JoinColumn(name = "training_day_id", nullable = false)
    TrainingDay trainingDay;

    @OneToMany(mappedBy = "exerciseGroup", cascade = CascadeType.ALL)
    List<TrainingExerciseGroupDetail> exercises;
}
