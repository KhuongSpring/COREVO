package com.example.corevo.domain.entity.training.training_personal;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDate;
import java.util.List;

@Entity
@Table(name = "personal_training_days")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class PersonalTrainingDay {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "personal_training_plan_id", nullable = false)
    PersonalTrainingPlan personalTrainingPlan;

    @Column(name = "day_number", nullable = false)
    Integer dayNumber;

    @Column(name = "actual_date", nullable = false)
    LocalDate actualDate;

    @Column(name = "is_rest_day")
    Boolean isRestDay;

    @OneToMany(mappedBy = "personalTrainingDay", cascade = CascadeType.ALL)
    List<PersonalTrainingExercise> exercises;
}
