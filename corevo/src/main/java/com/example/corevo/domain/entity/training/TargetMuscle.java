package com.example.corevo.domain.entity.training;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "target_muscle")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TargetMuscle {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    Long id;
    String targetMuscleName;
}
