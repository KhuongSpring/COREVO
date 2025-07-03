package com.example.corevo.domain.entity.training;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.util.List;

@Entity
@Table(name = "training_exercise")
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class TrainingExercise {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    Long id;

    @Column(nullable = false)
    String name;

    @Column(nullable = false)
    String imageURL;

    @Lob
    @Column(columnDefinition = "TEXT")
    String description;

    @Column(nullable = false)
    Integer minSet;

    @Column(nullable = false)
    Integer maxSet;

    @Column(nullable = false)
    Integer minRep;

    @Column(nullable = false)
    Integer maxRep;

    @Column(nullable = false)
    Integer minDuration;

    @Column(nullable = false)
    Integer maxDuration;

    @ManyToMany
    @JoinTable(
            name = "training_exercise_levels",
            joinColumns = @JoinColumn(name = "training_exercise_id"),
            inverseJoinColumns = @JoinColumn(name = "level_id")
    )
    List<Level> levels;

    @ManyToMany
    @JoinTable(
            name = "training_exercise_types",
            joinColumns = @JoinColumn(name = "training_exercise_id"),
            inverseJoinColumns = @JoinColumn(name = "type_id")
    )
    List<Type> types;

    @ManyToMany
    @JoinTable(
            name = "training_exercise_primary_muscles",
            joinColumns = @JoinColumn(name = "training_exercise_id"),
            inverseJoinColumns = @JoinColumn(name = "target_muscle_id")
    )
    List<TargetMuscle> primaryMuscles;

    @ManyToMany
    @JoinTable(
            name = "training_exercise_secondary_muscles",
            joinColumns = @JoinColumn(name = "training_exercise_id"),
            inverseJoinColumns = @JoinColumn(name = "target_muscle_id")
    )
    List<TargetMuscle> secondaryMuscles;

    @ManyToMany
    @JoinTable(
            name = "training_exercise_equipments",
            joinColumns = @JoinColumn(name = "training_exercise_id"),
            inverseJoinColumns = @JoinColumn(name = "equipment_id")
    )
    List<Equipment> equipments;

    @ManyToMany
    @JoinTable(
            name = "training_exercise_locations",
            joinColumns = @JoinColumn(name = "training_exercise_id"),
            inverseJoinColumns = @JoinColumn(name = "location_id")
    )
    List<Location> locations;

    @ManyToMany
    @JoinTable(
            name = "training_exercise_goals",
            joinColumns = @JoinColumn(name = "training_exercise_id"),
            inverseJoinColumns = @JoinColumn(name = "goal_id")
    )
    List<Goal> goals;

}
