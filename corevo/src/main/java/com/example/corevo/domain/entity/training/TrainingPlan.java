package com.example.corevo.domain.entity.training;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.util.List;

@Entity
@Table(name = "training_plan")
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
@ToString
public class TrainingPlan {

        @Id
        @GeneratedValue(strategy = GenerationType.IDENTITY)
        Long id;

        @Column(nullable = false)
        String name;

        String description;

        String aim;

        @Column(nullable = false)
        String goals;

        @Column(nullable = false)
        String type;

        @Column(nullable = false)
        String duration;

        @Column(nullable = false)
        String frequency;

        @ManyToMany
        @JoinTable(name = "training_plan_levels", joinColumns = @JoinColumn(name = "training_plan_id"), inverseJoinColumns = @JoinColumn(name = "level_id"))
        List<Level> levels;

        @ManyToMany
        @JoinTable(name = "training_plan_locations", joinColumns = @JoinColumn(name = "training_plan_id"), inverseJoinColumns = @JoinColumn(name = "location_id"))
        List<Location> locations;

        @ManyToMany
        @JoinTable(name = "training_plan_equipments", joinColumns = @JoinColumn(name = "training_plan_id"), inverseJoinColumns = @JoinColumn(name = "equipment_id"))
        List<Equipment> equipments;

}
