package com.example.corevo.domain.entity.training.training_schedule_details;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

@Entity
@Table(name = "training_day")
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class TrainingDay {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    Long id;

    @Enumerated(EnumType.STRING)
    DayOfWeek dayOfWeek;

    @Column(nullable = false)
    String name;

    String duration;

    String location;

    String description;

    @ManyToOne
    @JoinColumn(name = "schedule_id", nullable = false)
    TrainingSchedule trainingSchedule;

    @OneToOne(mappedBy = "trainingDay", cascade = CascadeType.ALL, fetch = FetchType.EAGER)
    TrainingExerciseGroup exerciseGroup;

}
