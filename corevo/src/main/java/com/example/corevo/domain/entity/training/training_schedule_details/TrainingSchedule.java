package com.example.corevo.domain.entity.training.training_schedule_details;

import com.example.corevo.domain.entity.training.TrainingPlan;
import com.example.corevo.domain.entity.user.User;
import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.util.List;

@Entity
@Table(name = "training_schedule")
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class TrainingSchedule {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    Long id;

    @ManyToOne
    @JoinColumn(name = "user_id")
    User user;

    @ManyToOne
    @JoinColumn(name = "training_plan_id", nullable = false)
    TrainingPlan trainingPlan;

    @OneToMany(mappedBy = "trainingSchedule", cascade = CascadeType.ALL)
    List<TrainingDay> days;

}
